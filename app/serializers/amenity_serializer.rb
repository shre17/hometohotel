class AmenitySerializer < ActiveModel::Serializer
  attributes :title, :description, :amenity, :safety_amenity, :shared_spaces, :icon_url

  def icon_url
    # "https://s3.ca-central-1.amazonaws.com/homes2hotels/mobile/amenity/#{object.title}.png"
    "https://s3.ca-central-1.amazonaws.com/homestohotels/mobile/amenity/#{Place::IMAGES_RIGHT_NAME[object.title].downcase}.png"
  end
end
