class PlacesController < ApplicationController
  include FilterController
  before_action :set_host, only: [:new, :edit, :update, :destroy, :create, :back_step]
  before_action :set_place, only: [:edit, :update, :destroy, :back_step]
  before_action :get_place, :record_view, only: [:show]
  after_action :create_blocked_dates, only: :update

  def address_validation
    resource = params[:type].constantize.find(params[:id])
    resource.location.update(latitude: params[:latitude], longitude: params[:longitude])
    if((resource.location.latitude.present?) && (resource.location.longitude.present?))
      status = true
    else
      status = false
    end
  end

  def index
    @places = Place.joins(:location, :price)
    get_places_based_on_city if params[:city].present?
    filter_places_data if filter_params.present?
  end

  def show
    @is_admin_verified = (params[:admin_verified].present? && !current_user.profile.profile_verified.present?) ? false : true
    @place = Place.find(params[:id])
    similar_places
  end

  def create_review
    @resource = params[:review][:reviewable_type].constantize.find(params[:id])
    @review = @resource.reviews.new(review_params.merge({user_id: current_user.id}))
    @review.save
    respond_to :js
  end

  def new
    @place = @host.places.new
    @all_places = current_user.host.places
  end

  def edit;end

  def create
    unless current_user.host
      current_user.build_host.save
      set_host
    end

    @place = @host.places.new(place_params)
    #@place.add_default_category
    respond_to do |format|
      if @place.save
        format.html { redirect_to edit_place_path(@place), notice: 'Place was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    modifiy_params if params[:place][:step].eql?("3")
    update_guest_details if params[:place][:details_guest_must_knows]
    update_checkin_checkout if params[:place][:check_in_date_from].present?
    redirect_path = if @place.update(place_params)
                      if (params[:step] || @place.step).to_i >= 18
                        @place.update_attributes(is_created: true)
                        @place
                      elsif params[:step].present?
                        edit_place_path(@place, step: params[:step])
                      else
                        edit_place_path(@place)
                      end
                    else
                      edit_place_path(@place)
                    end
    flash[:notice] = 'Place was successfully updated.' if params[:place][:step].to_i>15
    redirect_to redirect_path
  end

  def modifiy_params
    params[:place][:bedrooms_attributes].keys.each do |key|
      beds_content = params[:place][:bedrooms_attributes][key]["beds_attributes"]
      no_of_attached_bathrooms = beds_content[beds_content.keys.first][:bedroom]["no_of_attached_bathrooms"]
      beds_content[beds_content.keys.first].delete("bedroom")
      params[:place][:bedrooms_attributes][key]["no_of_attached_bathrooms"] = no_of_attached_bathrooms
    end
  end

  def update_guest_details
    guest_details  = GuestDetail.where(id: params[:place][:details_guest_must_knows])
    unchecked_data = @place.guest_details.map(&:title) - guest_details.map(&:title)
    if unchecked_data.any?
      unchecked_data.each do |title|
        guest_record = @place.guest_details.find_by_title(title)
        guest_record.delete
      end
    else
      guest_details.each do |guest_detail|
        @place.guest_details.find_or_create_by(title: guest_detail.title)
      end
    end
  end

  def update_checkin_checkout
    dates_range = params[:place][:check_in_date_from].split(" - ")
    params[:place][:check_in_date_from] = dates_range[0]
    params[:place][:check_in_date_to] = dates_range[1]
  end

  def create_blocked_dates
    if params[:place][:blocked_dates_in_range].present?
      start_date = Date.parse(params[:place][:blocked_dates_in_range].split("-")[0])
      end_date = Date.parse(params[:place][:blocked_dates_in_range].split("-")[1])
      (start_date..end_date).each do |day|
        @place.blocked_dates.create(blocked_date: day)
      end
    end
  end

  def back_step
    redirect_to edit_place_path(@place)
  end

  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_places_based_on_city
    @city = params[:city]
    @places = @places.where(:locations => {:city => params[:city]})
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

  def location_fetch
    value = params[:value].to_sym
    @for = params[:field]
    @next_for = @for.eql?('state') ? 'city' : ''
    @data = case @for
              when 'state'
                CS.states(value)
              when 'city'
                CS.cities(value, params[:country].to_sym)
              end
  end

  private
    def get_place
      @place = Place.find(params[:id])
    end

    def set_host
      @host = current_user.host
    end

    def set_place
      @place = @host.places.find(params[:id])
    end

    def record_view
      @view = @place.views.where(ip_address: request.remote_ip).first_or_create
      @view.update(no_of_time: @view.no_of_time.to_i+1, user_id: current_user.try(:id))
      @view.save
    end

    def review_params
      if params[:review][:reviewable_type].eql?("Place")
        params.require(:review).permit(:accuracy, :amenities, :communication, :user_id, :checkin, :cleanliness, :food_quality, :service, :reviewable_id, :location, :content)
      else
        params.require(:review).permit(:content, :service, :user_id, :reviewable_id)
      end
    end

    def place_params
      params.require(:place).permit(:step, :category_id, :property_type_id, :number_of_rooms, :what_will_guest_have, :dedicated_guest_space, :number_of_guests, :guest_can_book_before, :number_of_bedrooms, :number_of_beds, :number_of_common_bathrooms, :private_bathroom,:rented_out_your_place_before, :often_do_you_want_to_have_guests,:check_in_time_from, :check_in_time_to, :check_in_date_from, :check_in_date_to, :offer_id ,{amenities: [],safety_amenities: [], shared_spaces: []}, :name, :description, :guest_arrives_notice, :check_in_from, :check_in_to, :advance_booking_period, :stay_upto_min, :stay_upto_max,
        bedrooms_attributes: [:id, :common_space, :total_beds,:no_of_attached_bathrooms, :_destroy,beds_attributes: [:id, :double, :queen, :single, :sofa_bed, :king_bed, :couch, :bunk_bed, :floor_mattress, :air_mattress, :crib, :toddler_bed, :hammock, :water_bed]],
        location_attributes: [:id, :street, :apt, :city, :state, :country, :zipcode, :latitude, :longitude, :_destroy], rules_attributes: [:id, :title, :description, :status, :_destroy],images_attributes: [:id, :avatar, :description, :_destroy],price_attributes: [:id, :base_price, :minimum, :maximum, :currency, :service_fee, :cleaning_fee, :tax, :_destroy], blocked_dates_attributes: [:id, :blocked_date, :blockable_type, :blockable_id, :_destroy])
    end
end
