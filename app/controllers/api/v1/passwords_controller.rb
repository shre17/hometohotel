module Api::V1
  class PasswordsController < Devise::PasswordsController

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?
      if successfully_sent?(resource)
        @message = "password reset instructions sent to your email address"
        render json: {status: "success", success: @message}
      else
        @message = "please check your email address"
        render json: {status: "failed", error: @message}
      end
    end
  end
end