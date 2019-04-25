class ListingsController < ApplicationController
  before_action :check_authentication
  before_action :set_place, only: [:show]
  before_action :get_user_profile, only: [:show]

  def index
    @places = current_user.host.places.paginate(:page => params[:page], :per_page => 5) rescue {}
  end

  def update

  end

  def show
    @photos = @place.images
  end

  private

  def check_authentication
    redirect_to root_path, notice: "You are not authorized to view this page" unless (user_signed_in? && current_user.is_host?)
  end

  def set_place
    @place = Place.find(params[:id])
  end

  def get_user_profile
    @profile = @place.host.user.profile
  end
end
