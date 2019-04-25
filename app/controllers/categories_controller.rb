class CategoriesController < ApplicationController
  before_action :set_category
  before_action :authenticate_user!, except: [ :get_property, :set_category ]

  def get_property
	  render :json => { data: @category.property_types.pluck(:id, :title) }
  end

  private
	def set_category
	  @category = Category.find(params[:id])
	end
end
