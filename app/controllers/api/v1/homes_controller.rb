module Api::V1
  class HomesController < ApplicationController
    include HomesHelper

    def index
      @data = top_rated_places_and_experiences
      render json: {data: @data}
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
      render json: {data: @data, top_rated: @top_rated}
    end
  
  end
end