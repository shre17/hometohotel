class HomesController < ApplicationController
  include FilterController
  layout 'main_layout' 
  def index
    # @places = Place.joins(:location, :price)
    @places = Place.joins(:location, :host).where('places.published': true).where('hosts.active': true)
    @experiences = Experience.joins(:location, :host).where('experiences.published': true).where('hosts.active': true)
    if filter_params.present?
      session[:filter_params] = filter_params
      filter_experiences_data
      filter_places_data
    end
  end

  def explore_city
    @city = params[:city]
    @data = {}
    @top_rated = {}
    %w(Place Experience).each do |find_in|
      @data[find_in] = find_in.constantize.joins(:location).where(locations: {city: params[:city].downcase})
      @data[find_in] = @data[find_in].joins(:reviews).group_by(&:id)
      if @data[find_in].present?
        @top_rated[find_in] = @data[find_in].sort_by{|k,v| v.count}.reverse
      else
        @data[find_in] = find_in.constantize.joins(:location).where(locations: {city: params[:city].downcase})
      end
    end
  end

end
