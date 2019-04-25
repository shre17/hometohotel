class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user, @error = User.from_omniauth(request.env["omniauth.auth"], current_user)
    after_signup_redirect_to('Facebook')
  end

  def google_oauth2
    @user, @error = User.from_omniauth(request.env["omniauth.auth"], current_user)
    after_signup_redirect_to('Google')
  end

  def after_signup_redirect_to(kind)
    if current_user.present?
      redirect_to set_trust_and_verification_profile_path(current_user.profile)
    elsif @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: kind)
      sign_in_and_redirect @user
    else
      redirect_to new_user_registration_url, notice: @error
    end
  end

end
