class BookingsController < ApplicationController
  require "rubygems"
  require "braintree"

  before_action :set_session_values, only: [:create]
  before_action :update_params, only: [:continue_pending_booking]
  before_action :get_type, only: [:create, :continue_pending_booking]
  before_action :validate_required_params, only: [:create]
  before_action :set_braintree_token, only: [:pay_via_braintree]
  before_action :get_booking , only: [:show, :booking_invoice, :express_checkout, :after_paypal_chackout, :exp_booking_invoice, :download_invoice, :pay_via_braintree, :braintree_checkout, :check_booking, :accept, :decline]
  before_action :check_user_authorization, only: [:check_booking, :accept, :decline]

  def index;end

  def create
    continue_pending_booking
  end

  def check_booking;end

  def continue_pending_booking
    if current_user.profile.incomplete_profile?
      missing_fields = ''
      %w(first_name last_name gender date month year email contact_no).map{ |field| missing_fields += field.titleize.capitalize+" " if current_user.profile.send(field).blank? }
      redirect_to edit_profile_path(current_user.profile), notice: "You must complete your profile first! #{missing_fields} are missing."
    elsif current_user.profile.govt_id_soft_copy.present? && current_user.profile.profile_verified.present?
      @booking = @hosting_type.bookings.new(booking_params.merge({user_id: current_user.id}))
      if @booking.save
        if @booking.bookable.class.name.eql?('Experience')
          @booking.update_amount_for_all_guest
        else
          @booking.update_service_and_other_charges
        end
        session[:pending_booking] = false
        redirect_path = if @hosting_type.class.name == "Place"
                          booking_invoice_bookings_path(id: @booking)
                        else
                          exp_booking_invoice_bookings_path(id: @booking)
                        end
        redirect_to redirect_path
      else
        render :action => "failure"
      end
    else
      if current_user.profile.govt_id_soft_copy.blank?
        profile_submit = current_user.profile.govt_id_soft_copy ? true : false
        redirect_to set_trust_and_verification_profile_path(current_user.profile, profile_submit: profile_submit), notice: "You must complete your account verification first, by providing Government Approved ID."
      else current_user.profile.profile_verified.present?
        admin_verified = current_user.profile.profile_verified ? true : false
        redirect_to place_path(params[:id], admin_verified: admin_verified)
      end
    end
  end

  def show;end

  def download_invoice
    if @booking.bookable_type.eql?('Experience')
      @experience = @booking.bookable
      @template = 'bookings/confirm_exp_booking_pdf.html'
    else
      @place = @booking.bookable
      @template = 'bookings/confirm_booking_pdf.html'
    end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name",
          template: @template,
          orientation: 'Portrait',
          page_size: 'A4',
          page_height: 200,
          page_width: 180,
          margin: {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0
          },
          background: true
      end
    end
  end

  def after_paypal_chackout
    @reservation = @booking.build_reservation(:express_token => params[:token], ip: request.remote_ip)
    if @reservation.save
      if @booking.reservation.purchase
        @booking.update(payment_status: true)
        MailerMailer.notify_host(current_user, @booking).deliver
        MailerMailer.payment_sucessfull_mail(current_user, @booking).deliver
        flash[:notice] = 'Payment Suceed'
        redirect_path = if @booking.bookable.class.name == "Place"
                        booking_invoice_bookings_path(id: @booking)
                      else
                        exp_booking_invoice_bookings_path(id: @booking)
                      end
      redirect_to redirect_path
      else
        render :action => "failure"
      end
    end
  end

  def booking_invoice
    @place = @booking.bookable
  end

  def exp_booking_invoice
    @experience = @booking.bookable
  end

  def express_checkout
    response = EXPRESS_GATEWAY.setup_purchase(@booking.price_in_cents,
      ip: request.remote_ip,
      return_url: after_paypal_chackout_booking_url(@booking),
      cancel_return_url: place_url(@booking.bookable),
      currency: "USD",
      allow_guest_checkout: true,
      items: [{name: "Booking", description: "Home Booking", quantity: "1", amount: @booking.price_in_cents}]
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def booking_history
    @bookings = current_user.bookings
  end

  def booking_history_show
    @bookings = current_user.bookings
    if params[:data].eql?("Experience")
      @experiences = booked_experiences(@bookings)
    else
      @places = booked_places(@bookings)
    end
  end

  def transaction_history
    @bookings = current_user.bookings.where(payment_status: true)
  end

  # Braintree payment
  def pay_via_braintree;end

  def braintree_checkout

    # @result = Braintree::Transaction.sale(
    #   amount: @booking.total,
    #   payment_method_nonce: params[:payment_method_nonce],
    #   merchant_account_id: @booking.merchant_id,
    #   service_fee_amount: "1.00"
    # )
    set_braintree_gateway
    @result = @gateway.transaction.sale(
      :merchant_account_id => @booking.merchant_id,
      :amount => @booking.final_price,
      :payment_method_nonce => params[:payment_method_nonce],
      :service_fee_amount => "1.00"
    )
    if @result.success?
      set_reservation
      # hold_in_escrow
      # release_from_escrow # After 48 hours of confirmation, release the amount to host
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      render :pay_via_braintree
    end
  end

  def set_reservation
    @reservation = @booking.build_reservation(braintree_transaction_id: @result.transaction.id, ip: request.remote_ip)
    if @reservation.save
      @booking.update(payment_status: true)
      MailerMailer.notify_host(current_user, @booking).deliver
      MailerMailer.payment_sucessfull_mail(current_user, @booking).deliver
      flash[:notice] = 'Payment Suceed'
      redirect_path = if @booking.bookable.class.name == "Place"
                        booking_invoice_bookings_path(id: @booking)
                      else
                        exp_booking_invoice_bookings_path(id: @booking)
                      end
      redirect_to redirect_path
    else
      render :action => "failure"
    end
  end

  def accept
    @booking.update(accepted_by_host: true)
    redirect_to check_booking_booking_path(@booking)
  end

  def decline
    @booking.update(accepted_by_host: false)
    # MailerMailer.notify_user_about_cancellation(@booking).deliver
    # refund fund from escrow to user
    redirect_to check_booking_booking_path(@booking)
  end

  private

  def booking_params
    params.require(:booking).permit(:total_guest, :start_date, :end_date,:total, :place_id, :express_token, :price, :exp_start_time, :exp_end_time, :exp_date, :currency)
  end

  def check_user_authorization
    redirect_to root_path, notice: 'You are not authorized to view this page' unless (user_signed_in? && current_user.is_host?)
    redirect_to root_path, notice: 'There is no associated booking with this id for your account.' unless (@booking.bookable.host.user == current_user)
  end

  def hold_in_escrow
    @gateway.transaction.hold_in_escrow(@result.transaction.id)
  end

  def release_from_escrow
    @gateway.transaction.release_from_escrow(@result.transaction.id)
  end

  def get_booking
    @exp_booking = @booking = Booking.find(params[:id])
  end

  def get_type
    @hosting_type = params[:booking][:bookable_type].constantize.find(params[:id])
  end

  def set_braintree_token
    gon.client_token = generate_client_token    
  end

  def generate_client_token
    Braintree::ClientToken.generate
  end

  def set_braintree_gateway
    @gateway = Braintree::Gateway.new(
      :environment => :sandbox,
      :merchant_id => Rails.application.secrets[:braintree][:merchant_id],
      :public_key => Rails.application.secrets[:braintree][:public_key],
      :private_key => Rails.application.secrets[:braintree][:private_key],
    )
  end

  def set_session_values
    session[:pending_booking] = true
    session[:booking_params] = params[:booking]
    session[:params_id] = params[:id]    
  end

  def update_params
    params[:id] = session[:params_id]
    params[:booking] = session[:booking_params] unless params[:booking].present?
  end

  def validate_required_params
    if params[:booking][:bookable_type].eql?('Place')
      flash[:error] = []
      %w(total_guest start_date end_date price total currency).each do |field|
        flash[:error] << "#{field.capitalize.titleize} can't be blank" unless booking_params[field].present?
      end
      redirect_to @hosting_type if flash[:error].present?
    end
  end   

end
