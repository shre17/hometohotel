module Api::V1
  class PlacesController < BaseApiController

    def index
      data = Place.with_city.group_by(&:get_cities)
      data = data.sort_by{|k,v| v.count}.reverse
      @data = data.first(4)
      @places = Place.joins(:location).where(:locations => {:city => params[:city]})if params[:city].present?
    end

    def get_category_list
      @categoeries = Category.where(place: true).pluck(:title, :id)
      render json: {status: "Success", category: @categoeries}
    end

    def show
      begin
        @place = Place.find(params[:id])
        similar_places
        @status = 'success'
      rescue
        @status = 'error'
      end

      render json: { status: @status, place: (@place.present? ? PlaceSerializer.new(@place) : nil), similar_places: @similar_places }
    end

    def similar_places
      @similar_places = Place.where.not(id: @place.id).joins(:location).where(locations: {city: @place.location.city})
      query = if @place.what_will_guest_have.present?
                ["what_will_guest_have = ? AND rating >= ? ", @place.what_will_guest_have, @place.rating]
              else
                ["rating >= ?", @place.rating]
              end
      @similar_places = @similar_places.where(query)
    end
  end

end
