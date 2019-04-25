module FilterController

  # Filters for places
  def filter_places_data
    update_price_filter if filter_params.present?

    place_filter_by_query if filter_params[:query].present?

    place_filter_by_price if filter_params[:price].present? && filter_params[:price][:maximum].present?

    place_filter_by_guest_have if filter_params[:what_will_guest_have].present?

    place_filter_by_guest if filter_params[:guest].present? && filter_params[:guest][:adult].present?

    place_filter_by_date if filter_params[:check_in].present?
  end

  def place_filter_by_query
    @locations = Location.search_by_full_address(filter_params[:query])
    @places = Place.joins(:location, :host, :price).where('locations.id': @locations.pluck(:id)).where('places.id': @places.map(&:id), 'places.published': true).where('hosts.active', true)
  end

  def place_filter_by_price
    @places = @places.where("prices.base_price": (filter_params[:price][:minimum].to_i..filter_params[:price][:maximum].to_i))
  end

  def place_filter_by_guest_have
    @places = @places.where(what_will_guest_have: filter_params[:what_will_guest_have])
  end

  def place_filter_by_guest
    @places = @places.where("number_of_guests >= ?", filter_params[:guest][:adult])
  end

  def place_filter_by_date
    @places = @places.map{ |place| check_booking_availability_for_place(place) }.compact
  end

  def check_booking_availability_for_place(place)
    availability = []
    (filter_params[:check_in].to_date..filter_params[:check_out].to_date).map do |date|
      unless place.blocked_dates.where(blocked_date: date).present?
        guest_booking = place.bookings.where(start_date: date).sum(:total_guest)    
        if (guest_booking + filter_params[:guest][:adult].to_i) <= place.number_of_guests.to_i
          availability << true
          break
        else
          availability << false
        end
        availability = availability.include?(true)
      else
        availability = false
        break
      end
    end
    return availability ? place : nil
  end

  # Filters for experiences
  def filter_experiences_data
    update_price_filter if filter_params.present?

    exp_filter_by_query if filter_params[:query].present?

    exp_filter_by_price if filter_params[:price].present? && filter_params[:price][:maximum].present?

    exp_filter_by_time_of_day if filter_params[:hosting_start_time].present?

    exp_filter_by_guest if filter_params[:guest][:adult].present?

    exp_filter_by_date if filter_params[:check_in].present?
  end

  def exp_filter_by_query
    @locations = Location.search_by_full_address(filter_params[:query])
    @experiences = @experiences.where('experiences.published': true).where('hosts.active': true).where('locations.id': @locations.pluck(:id))   
  end

  def exp_filter_by_price
    @experiences = @experiences.where("price_per_guest": (filter_params[:price][:minimum].to_i..filter_params[:price][:maximum].to_i))
  end

  def exp_filter_by_time_of_day
    query_array = []
    query = ''
    if filter_params[:hosting_start_time].include?('morning')
      query += 'hosting_start_time >= ? AND hosting_start_time < ?'
      query_array << '0'
      query_array << '12'
    end
    if filter_params[:hosting_start_time].include?('afternoon')
      query += ' OR ' unless query.blank?
      query += 'hosting_start_time >= ? AND hosting_start_time < ?'
      query_array << '12'
      query_array << '17'
    end
    if filter_params[:hosting_start_time].include?('evening')
      query += ' OR ' unless query.blank?
      query += 'hosting_start_time >= ? AND hosting_start_time < ?'
      query_array << '17'
      query_array << '20'
    end
    if filter_params[:hosting_start_time].include?('night')
      query += ' OR ' unless query.blank?
      query += 'hosting_start_time >= ? AND hosting_start_time <= ?'
      query_array << '20'
      query_array << '23'
    end
    full_query = query_array.unshift(query)
    @experiences = @experiences.where(full_query)
  end

  def exp_filter_by_guest
    @experiences = @experiences.where("max_group_size >= ?", filter_params[:guest][:adult])
  end

  def exp_filter_by_date
    @experiences = @experiences.map{ |exp| check_booking_availability_for_exp(exp) }.compact
  end

  def update_price_filter
    if filter_params[:price].present?
      params[:filter][:price][:minimum] = nil if filter_params[:price][:minimum].blank?
      params[:filter][:price][:maximum] = 1000 if filter_params[:price][:minimum].present? && filter_params[:price][:maximum].blank?
    end
  end

  def check_booking_availability_for_exp(exp)
    availability = []
    (filter_params[:check_in].to_date..filter_params[:check_out].to_date).map do |date|
      guest_booking = exp.bookings.where(start_date: date).sum(:total_guest)    
      if (guest_booking + filter_params[:guest][:adult].to_i) <= exp.max_group_size.to_i
        availability << true
        break
      else
        availability << false
      end
    end
    return (availability.include?(true) ? exp : nil)
  end

  def filter_params
    return false if params[:filter].blank?
    if (params[:filter][:check_in].present? && params[:filter][:check_out].blank?)
      params[:filter][:check_out] = params[:filter][:check_in].to_date + 1.day
    elsif (params[:filter][:check_out].present? && params[:filter][:check_in].blank?)
      params[:filter][:check_in] = params[:filter][:check_out].to_date - 1.day
    end
    params.require(:filter).permit(:query, :check_in, :check_out, guest: [:adult, :child], what_will_guest_have: [], hosting_start_time: [], price: [:minimum, :maximum] )
  end
end
