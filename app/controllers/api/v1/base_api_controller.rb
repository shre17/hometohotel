module Api::V1
  class BaseApiController < ApplicationController
    before_action :get_current_user
  end
end
