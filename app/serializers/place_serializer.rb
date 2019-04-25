class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :category_id, :category_title, :property_type_id, :property_type_title, :rating, :description, :number_of_rooms, :what_will_guest_have, :dedicated_guest_space, :number_of_guests, :number_of_bedrooms, :number_of_beds, :private_bathroom, :host_id, :host_details, :photos, :amenities, :all_safety_amenities, :all_shared_spaces, :stay_upto_min, :stay_upto_max, :guest_arrives_notice, :check_in_date_from, :check_in_date_to, :check_in_time_from, :check_in_time_to, :advance_booking_period, :guest_can_book_before, :reviews, :location, :rules, :price_detail, :total_reviews, :number_of_common_bathrooms#, :number_of_bathrooms
    # :similar_places

  has_many :reviews
  has_many :amenities

  def similar_places
    self.instance_options[:similar_places]
  end

  def category_title
    self.object.category.title rescue nil
  end

  def property_type_title
    self.object.property_type.title rescue nil
  end

  def host_details
    self.object.host.user.profile rescue nil
  end

  def photos
    self.object.images
  end

  def total_reviews
    self.object.reviews.try(:count) rescue nil
  end

  def amenities
    Amenity.find(object.amenities) rescue []
  end

  def all_safety_amenities
    self.object.get_safety_amenities rescue []
  end

  def all_shared_spaces
    self.object.shared_spaces.map{ |id| Place::SPACES[id] } rescue []
  end

  def reviews
    self.object.reviews.try(:first)
  end

  def location
    self.object.location
  end

  def rules
    self.object.rules
  end

  def price_detail
    self.object.price
  end
end
