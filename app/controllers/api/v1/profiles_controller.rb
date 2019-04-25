module Api::V1
  class ProfilesController < BaseApiController
    before_action :validate_params, only: [:update, :upload_profile_picture, :show, :upload_ids]
    before_action :set_profile, only: [:update, :upload_profile_picture, :show, :upload_ids]

    #skip_before_action :get_current_user, only: [:show]

    def update
      #raise "Invaid Token for User ID: #{params[:id]}" unless @current_user.id == params.require(:id)
      if params[:profile][:languages].present?
        @profile.languages = params[:profile][:languages]
        @profile.save
      end
      @profile.update(params_profile) if params[:profile].present?
      render :show
    # rescue => e
    #   render json: {status: e.message }, status: 406
    end

    def show_review
      if @current_user.host.reviews.present?
        @reviews = @current_user.host.reviews
      else
        render json: {status: "success", message: 'You have No Review Yet'}
      end
    end

    def upload_profile_picture
      if params[:profile].present?
        @profile.update(params_profile_picture)
        #get_json_reponse
      end
    end

    def upload_ids
      @profile.update(params_trust_and_verification) if params[:profile].present?
      #get_json_reponse
    end

    # def upload_ids
    #   @profile.update(params_trust_and_verification) if params[:profile].present?
    #   get_json_reponse
    # rescue => e
    #   render json: { status: 'failure', error: e.message }, status: 404
    # end

    def show
    end

    # def create_favourite
    #   #@resource = params[:type].constantize.find(params[:id])
    #   #@favourite = @resource.favourites.where(user_id: get_current_user).first_or_initialize
    #   # @resource = params[:type].constantize.find(params[:place_id])
    #   # @favourite = @resource.favourites.where(user_id: params[:id]).first_or_initialize
    #   # @liked = !@favourite.persisted?
    #   # begin
    #   #   @favourite.persisted? ? @favourite.delete : @favourite.save
    #   #   @status = "success"
    #   # rescue
    #   #   @status = "error"
    #   # end
    #   # #@fav_count = get_current_user.favourites.where(favouritable_type: params[:type]).count
    #   # @fav_count = User.find(params[:id]).favourites.where(favouritable_type: params[:type]).count
    #   # render json: {status: @status , liked: @liked, fav_count: @fav_count, place_id: params[:place_id], type: params[:type]}
    # end

    private

      def params_profile
        params.require(:profile).permit(:first_name, :last_name, :gender, :date, :month, :year, :prefered_language, :prefered_currency, :city, :languages, :describe_yourself, :work_email, :email, :contact_no, :work, :school, :time_zone,  guest_profiles_attributes: [:id, :first_name, :last_name, :nationality, :passport_number, :date, :year, :month, :_destroy], emergency_contact_attributes: [:id, :name, :phone, :email, :relationship, :_destroy], vat_number_attributes: [:id, :member_state, :vat_number, :vat_name, :vat_address_line_1, :vat_optional_address_line_2, :vat_city, :vat_state, :vat_zip, :_destroy])
      end

      def params_trust_and_verification
        params.require(:profile).permit(:govt_id_soft_copy, :user_current_image)
      end

      def set_profile
        @profile = Profile.find(params[:id])
      end

      def validate_params
        raise "Invaid Token for User ID: #{params[:id]}" unless @current_user.id == params.require(:id).to_i
      rescue => e
        render json: {status: "failure", error: e.message}, status: 406
      end

      def params_profile_picture
        params.require(:profile).permit(:image)
      end

      def get_json_reponse
        render json: {status: "success", profile: @profile}
      end
  end
end
