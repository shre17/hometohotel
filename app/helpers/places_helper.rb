module PlacesHelper
	def get_amenities
		Amenity.where(amenity: true)
	end

	def get_safety_amenities
		Amenity.where(safety_amenity: true)
	end

	def get_guest_details
		GuestDetail.first(9)
	end

  def get_categories
    Category.where(place: true).pluck(:title, :id)
  end

  def get_properties(category)
    if category.present?
      category.property_types.pluck(:title, :id)
    else
      return []
    end
  end

  def sorted_cities
    data = Place.with_city.joins(:location, :host, :price).where.not('prices.base_price': nil).where('hosts.active': true).where('places.published': true).group_by(&:get_cities)
    data = data.sort_by{|k,v| v.count}.reverse
  end

  def top_rated_places
    data = Place.joins(:reviews).group_by(&:id)
    data = data.sort_by{|k,v| v.count}.reverse
  end

  def property_type similar_place
    PropertyType.find(similar_place.property_type_id).title
  end

  def city similar_place
    similar_place.location.city
  end

  def rating_comment rating
    if rating >= 4.0
      return "Superb"
    elsif rating >= 3.0
      return "Moderate"
    else
      return "Poor"
    end
  end

  def statistic data, star
    @reviews = if star.eql?(5)
                data.reviews.where("overall_rating >= ?", 4.5)
              else
                data.reviews.where("overall_rating >= ? AND overall_rating < ?", "#{star.to_f - 0.5}", "#{star.to_f + 0.5}")
              end
    rating = (@reviews.count/data.reviews.count.to_f) * 100
    return rating
  end

  def get_place_booking_dates(place)
    @dates = []
    bookings = place.bookings.where(payment_status: true)
    if bookings.present?
      bookings.each do |booking|
        @dates = Date.parse(booking.start_date.strftime("%d/%m/%Y"))..Date.parse(booking.end_date.strftime("%d/%m/%Y"))
      end
      return @dates.map{ |date| date.strftime("%d/%m/%Y")}
    end
  end

  def get_blocked_dates(place)
    return place.blocked_dates.collect{|b| b.blocked_date.strftime("%d/%m/%Y")}
  end

  def view_photos_btn_class
    if is_mobile_request?
      if user_signed_in? && @place.host.user.id.eql?(current_user.id)
        'btn_photos admin_btn_photos'
      else
        'btn_photos'
      end
    else
      'btn_photos'
    end
  end
end
