class Api::V1::UsersController < ApplicationController
	def create_favourite
		#@favourite = @resource.favourites.where(user_id: get_current_user).first_or_initialize
		@resource = params[:type].constantize.find(params[:place_id])
		@favourite = @resource.favourites.where(user_id: params[:id]).first_or_initialize
		@liked = !@favourite.persisted?
		begin
		  @favourite.persisted? ? @favourite.delete : @favourite.save
		  @status = "success"
		rescue
		  @status = "error"
		end
		@fav_count = User.find(params[:id]).favourites.where(favouritable_type: params[:type]).count
		render json: {status: @status , liked: @liked, fav_count: @fav_count, place_id: params[:place_id], type: params[:type]}
	end
end
