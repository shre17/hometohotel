module Api::V1
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token

    def create
      build_resource(sign_up_params)
      resource.save
      resource.profile.update(:name=> params[:user][:name]) if params[:user][:name].present?
      yield resource if block_given?
      if resource.persisted?
        resource.generate_auth_token!
        render json: {status: "success", user: resource}
      else
        msg = resource.errors.messages
        error_msg = check_errors(msg)
        render json: {status: "failed", error: error_msg}
      end
    end

    def generate_auth_token!(user)
      begin
        user.auth_token = Devise.friendly_token
      end while user.class.exists?(auth_token: user.auth_token)
    end

    def check_errors(msg)
      if msg[:email].present? && msg[:password_confirmation].present?
        error_msg = "email has already been taken and doesn't match Password"
      elsif msg[:email].present?
        error_msg = "email has already been taken"
      elsif msg[:password_confirmation].present?
        error_msg = "doesn't match Password"
      end
    end

    # def update
    #   debugger
    #   self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    #   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    #   resource_updated = update_resource(resource, account_update_params)
    #   yield resource if block_given?
    #   if resource_updated
    #     if is_flashing_format?
    #       flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
    #       :update_needs_confirmation : :updated
    #       set_flash_message :notice, flash_key
    #     end
    #     bypass_sign_in resource, scope: resource_name
    #     render json: {status: "success", user: resource}
    #     #redirect_to edit_user_registration_path, notice: "password changed successfully"
    #     #respond_with resource, location: edit_user_registration_path
    #   else
    #     clean_up_passwords resource
    #     set_minimum_password_length
    #     # respond_with resource
    #     render json: {status: "success", user: resource}
    #   end
    # end



    def update
      deubugger
    valid = @current_user.valid_password?(params[:user][:current_password])
    match_password = params[:user][:password] == params[:user][:password_confirmation]
    if valid && match_password
      if current_user.update_attributes(password: params[:user][:password])
      render json: {success: 'Password Update Successfully'}, status: 200
      else
        render json: {error: current_user.errors.full_messages.join()},status: 400
      end
    else
     message = {error: "password doesn't match"}  unless match_password
     message = {error: "current-password is not valid"} unless valid
     render json: message , status: 400
    end
  end

    def social_authentication
      provider = social_params.require(:provider)
      raise "Unknown Provider" unless provider.to_sym.in?(User.omniauth_providers)
      @resource = User.find_by_email(social_params[:email])

      password = Devise.friendly_token[0, 10] unless @resource

      case social_params[:provider]
      when "facebook"
        if @resource.present?
          unless @resource.facebook_uid.present?
            @resource.facebook_uid = social_params.require(:facebook_id)
            @resource.save!
          end
        else
          @resource = build_resource(email: social_params[:email],password: "password",facebook_uid: social_params[:facebook_id], confirmed_at: Time.now.utc)
        end
      when "google_oauth2"
        if @resource.present?
          unless @resource.google_oauth2_uid.present?
            @resource.google_oauth2_uid = social_params.require(:google_id)
            @resource.save!
          end
        else
          @resource = build_resource(email: social_params[:email],password: "password",google_oauth2_uid: social_params[:google_id], confirmed_at: Time.now.utc)
        end
      end
      @resource.generate_auth_token!
      profile =  Profile.find(@resource.id)
      profile.name = social_params[:username]
      profile.first_name = social_params[:username].split.first
      profile.last_name =social_params[:username].split.last
      profile.email = @resource.email
      profile.remote_image_url = social_params[:profile_pic]
      profile.save
      #render json: resource
    rescue => e
      render json: {error: e.message}, status: 403
    end

    private
    def social_params
      params.require(:registration).permit!
    end
  end
end
