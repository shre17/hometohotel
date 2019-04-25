module Api::V1
  class CategoriesController < BaseApiController
  before_action :set_category

    def get_property
      guest_have = Place::GUEST_HAVE
      property_types = @category.property_types.pluck(:id, :title)
      render json: {status: "Success", property_type: property_types, guest_have: guest_have}
      #render :json => { data: @category.property_types.pluck(:id, :title) }
    end

    private
    def set_category
      @category = Category.find(params[:id])
    end
  end
end
