class ProfilesController < ApplicationController
  before_action :set_profile, only: [:edit, :update, :show, :set_profile_picture, :upload_profile_picture, :set_trust_and_verification, :update_trust_and_verification, :generate_otp_for_phone_number_verification, :delete_language, :upload_ids]
  before_action :get_social_name, only: [:connect_to_social_account, :disconnect_from_social_account ]
  before_action :get_profile, only: [:verify_mobile_number, :resend_otp]

  def connect_to_social_account
    redirect_to send("user_#{@social}_omniauth_authorize_path")
  end

  def disconnect_from_social_account
    @profile = current_user.profile
    current_user.update("#{@social+"_uid"}": nil)
    respond_to do |format|
      format.html { redirect_to set_trust_and_verification_profile_path(@profile), notice: "your social account disconnected" }
    end
  end

  def delete_language
    @profile.languages.delete(params[:language])
    @profile.save
  end

  def edit;end

  def generate_otp_for_phone_number_verification
    if @profile.same_number_exist?(mobile_params)
      @success = false
      @error = "This number already exist in your profile"
    else
      @profile.update(mobile_params)
      @profile.generate_pin
      @profile.reload
      @success = @profile.send_pin.present? rescue false
      @error = "Number is invalid!" unless @success
    end
  end

  def resend_otp
    @profile.generate_pin
    @profile.reload
    @response = @profile.send_pin.present? rescue false
    @notice = @response ? "OTP sent on your registered mobile number successfully!" : "Due to some technical issue, request failed. Please try again."
  end

  def create_favourite
    @resource = params[:type].constantize.find(params[:id])
    @favourite = @resource.favourites.where(user_id: current_user).first_or_initialize
    @liked = !@favourite.persisted?

    @favourite.persisted? ? @favourite.delete : @favourite.save

    @fav_count = current_user.favourites.where(favouritable_type: params[:type]).count
    render json: { liked: @liked, fav_count: @fav_count, type: params[:type] }
  end

  def favourites
    @fav_experiences = current_user.favourites.for_experience.collect(&:favouritable)
    @fav_places = current_user.favourites.for_place.collect(&:favouritable)
  end

  def show;end

  def set_profile_picture;end

  def set_trust_and_verification
    @is_profile_submit = params[:profile_submit].eql?("false") ? false : true
  end

  def show_review;end

  def upload_ids
    @profile.update(params_trust_and_verification) if params[:profile].present?
    # redirect_to upload_ids_profile_path(@profile)
    if session[:pending_booking]
      redirect_to continue_pending_booking_bookings_path
    else
      redirect_back fallback_location: @profile, notice:  @profile.errors.try(:full_messages)
    end
  end

  def update
    if params[:languages].present?
      @profile.languages = params[:languages]
      @profile.save
      respond_to :json
    else
      @profile.update(params_profile) if params[:profile].present?
      path = if session[:pending_booking]
                continue_pending_booking_bookings_path
              else
                edit_profile_path(@profile)
              end
      respond_to do |format|
        format.html {redirect_to path, notice: "Profile updated successfully" }
      end
    end
  end

  def upload_profile_picture
    if params[:profile].present?
      @profile.update(params_profile_picture)
      respond_to do |format|
        format.html { redirect_to set_profile_picture_profile_path(@profile), notice: "Image Uploaded Successfully"}
      end
    end
  end

  def update_trust_and_verification
    # if params[:profile].present?
    #   @profile.update(params_trust_and_verification)
    #   respond_to do |format|
    #     format.html { redirect_to set_trust_and_verification_profiles_path(@profile), notice: "Id uploaded successfully"}
    #   end
    # end
  end

  def verify_mobile_number
    @otp_status = (@profile.otp == params[:otp]) ? true : false
    @notice = (@profile.otp == params[:otp]) ? "Number verified successfully!" : "Please enter a valid OTP!"
    @profile.update(mobile_verified: @otp_status)
  end

  private

    def params_profile
      params.require(:profile).permit(:first_name, :last_name, :gender, :date, :month, :year, :prefered_language, :prefered_currency, :city, :languages, :describe_yourself, :work_email, :email, :contact_no, :work, :school, :time_zone,  guest_profiles_attributes: [:id, :first_name, :last_name, :nationality, :passport_number, :date, :year, :month, :_destroy], emergency_contact_attributes: [:id, :name, :phone, :email, :relationship, :_destroy], vat_number_attributes: [:id, :member_state, :vat_number, :vat_name, :vat_address_line_1, :vat_optional_address_line_2, :vat_city, :vat_state, :vat_zip, :_destroy])
    end

    def params_profile_picture
      params.require(:profile).permit(:image)
    end

    def params_trust_and_verification
      params.require(:profile).permit(:govt_id_soft_copy, :user_current_image)
    end

    def set_profile
      @profile = Profile.find(params[:id])
    end

    def get_profile
      @profile = current_user.profile
    end

    def get_social_name
      @social = params[:name]
    end

    def mobile_params
      {contact_no: params[:profile][:contact_no], mobile_country: params[:profile][:mobile_country], mobile_verified: false}
    end
end