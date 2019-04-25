module BookingsHelper
  def booked_experiences bookings
    ids = bookings.where(bookable_type: "Experience").pluck(:bookable_id)
    experiences = []
    ids.each do |id|
      experiences.push(Experience.find(id))
    end  
    return experiences
  end

  def booked_places bookings
    ids = bookings.where(bookable_type: "Place").pluck(:bookable_id)
    places = []
    ids.each do |id|
      places.push(Place.find(id))
    end  
    return places
  end
end
