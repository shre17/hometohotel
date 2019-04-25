class Users::SessionsController < Devise::SessionsController
  def create
    @@method = "post"
    unless user_signed_in?
      self.resource = warden.authenticate!(auth_options)
      if self.resource.present?
        if self.resource.deactivation_flag.eql?(true)
          reset_session
          redirect_to reactivating_account_account_setting_path(self.resource)
        elsif user_signed_in?
          @status = "success"
          respond_to :js
        else
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          yield resource if block_given?
          @status = "success"
          self.resource.login_history_details(request.location)
          respond_to :js
        end
      end
    else
      redirect_to root_path
    end
  end

  def failure
    if defined?(@@method) != nil
      respond_to :js
    else
      redirect_to new_admin_user_session_path
    end
  end
end
