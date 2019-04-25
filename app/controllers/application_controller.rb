class ApplicationController < ActionController::Base
	# protect_from_forgery with: :null_session

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  TIME_OF_DAY_FILTER = { 'Morning' => '12 am', 'Afternoon' => '12 pm', 'Evening' => '5 pm', 'Night' => '8 pm' }

  before_action :set_device_type

  def get_current_user
    token = request.headers['Authorization'].presence
    if token
      @current_user ||= User.find_by_auth_token(token)
    end
    #head 401 unless @current_user
    render json: {status: "failure", error: 'Unauthorized'}, status: 401 unless @current_user
  end

  include ApplicationHelper

  def set_device_type
    gon.mobile_request = is_mobile_request?
  end

  def s3_static_content key
    "#{Rails.application.secrets[:s3][:s3_protocol]}:#{Rails.application.secrets[:s3][:s3_url_prefix]}/#{Rails.application.secrets[:s3][:s3_bucket]}/#{Rails.application.secrets[:s3][:assets_path]}/#{key}"
  end
end
