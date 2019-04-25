class Location < ApplicationRecord
  include PgSearch
  geocoded_by :address
  after_validation :geocode
  pg_search_scope :search_by_full_address, :against => [:street, :apt, :city, :state, :zipcode, :country]
  belongs_to :locationable, polymorphic: true


  def get_lat_long
    {lat: latitude, long: longitude}
  end

  def full_address
    # [apt, street, zipcode, city, state].compact.join(', ')
    [street, city, state, country].compact.join(', ')
  end

  def address
    [street, city, state, country].compact.join(', ')
  end
end
