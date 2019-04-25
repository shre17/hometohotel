class CustomFailure < Devise::FailureApp
  def redirect_url
    failure_path(:subdomain => 'secure')
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      flash[:alert] = i18n_message unless flash[:notice]
      redirect
    end
  end
end

