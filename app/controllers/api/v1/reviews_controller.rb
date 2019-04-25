module Api::V1
  class ReviewsController < BaseApiController
    def index
      begin
        @place = Place.find(params[:place_id])
        @reviews = @place.reviews || Review.all.first(5)
        @status = 'success'
      rescue
        @status = 'error'
      end
      render json: { status: @status, reviews: (@reviews.map{ |review| ReviewSerializer.new(review) }) }
    end
  end
end