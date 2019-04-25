module Api::V1
  class SessionsController < Devise::SessionsController
    respond_to :json
    skip_before_action :verify_authenticity_token
    before_action :ensure_params_exist, only: [:create]

    def create
      @resource = User.find_for_database_authentication(email: params[:user][:email])
      return invalid_login_attempt unless @resource
      if @resource.valid_password?(params[:user][:password])
        @resource.generate_auth_token!
        sign_in("user", @resource)
        #render json: {status: "success", user: resource}
        return
      end
      invalid_login_attempt
    end

    protected

      def ensure_params_exist
        return unless params[:user].blank?
        render json: {status: "failed", error: "Missing User Parameter"}
      end

      def invalid_login_attempt
        warden.custom_failure!
        render json: {status: "failed", error: "Error with your Email or password"}
      end

  end
end
