class HostsController < ApplicationController
  before_action :set_host, except: [:home, :experience]
  layout :set_layout, except: [:home, :experience]

  def dashboard;end

  def experience;end

  def home;end

  def hosted_places
    @hosted = @host.places rescue {}
  end

  def hosted_experiences
    @hosted = @host.experiences
  end

  # For place and experience
  def publish_n_unpublish
    @object = params[:class_name].constantize.find(params[:id])
    @object.update(published: !@object.published) if @object.author?(current_user)
  end

  # Index and create offer
  def offers    
    @host.offers.create(offer_params) if request.post?
    @offers = @host.offers
  end

  # Edit and update offer 
  def offer
    @offer = @host.offers.find(params[:id])
    @offer.update(offer_params) if request.put?
    redirect_to offers_host_path if request.put?
  end

  # Manage offer for places and update
  def manage_offer
    @offer = @host.offers.find(params[:id])
  end

  # Manage offer for places and update
  def manage_offer_for
    @offer_for = params[:for]
    @offer = @host.offers.find(params[:id])
    if request.post?
      if params[:places].present?
        @offer.places = []
        @offer.places << Place.find(params[:places])
      elsif params[:experiences].present?
        @offer.experiences = []
        @offer.experiences << Experience.find(params[:experiences])
      end
    end
  end

  # View Place / Experience detail
  def view_detail
    @object = params[:class_name].constantize.find(params[:id])
    set_object_data
  end

  # Update list of offers applied on object
  def change_object_offers
    @object = params[:class_name].constantize.find(params[:id])
    @offer = @host.offers.find(params[:offer_id])
    @offer_for = params[:class_name].pluralize.downcase
    if request.post?
      @object.offers = []
      @object.offers << Offer.find(params[:offers])
    end
  end

  private
    def offer_params
      params.require(:offer).permit(:title, :description, :discount, :max_discount, :weekly_discount, :monthly_discount)      
    end

    def set_host
      redirect_to root_path unless user_signed_in?
      @host = current_user.host rescue {}
      redirect_to root_path, notice: 'Your hosting account is Inactive!' unless @host.active? rescue {}
    end

    def set_layout
      'host_panel'
    end

    def set_object_data
      @data = {}
      @data[:object] = @object
      @data[:total_earnings] = @object.bookings.where(payment_status: true).sum(:total)
      @data[:total_guests] = @object.bookings.where(payment_status: true).sum(:total_guest)
      @data[:booked_no_of_time] = @object.bookings.where(payment_status: true).count
      @data[:incomplete_bookings] = @object.bookings.where(payment_status: false).count
      @data[:previous_bookings] = @object.bookings.where(payment_status: true).where("created_at <= ?", Date.today).count
      @data[:upcomming_bookings] = @object.bookings.where(payment_status: true).where("created_at > ?", Date.today).count
      @data[:reviews] = @object.reviews.count
      @data[:rating] = @object.rating
    end
end
