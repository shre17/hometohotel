unless @places.present?
  json.status "success"
  json.places @data do |data|
    json.count data[1].count
    json.city data[0]
    json.data data[1].first(4) do |place|
      json.place place
      json.price place.price.minimum
      json.image place.images.first.present? ? place.images.first.avatar.url : nil
      json.views place.views.count
    end
  end
else
  json.status "success"
  json.city @places.first.location.city
  json.places @places do |place|
    json.place place
    json.price place.price.minimum
    json.image place.images.first.present? ? place.images.first.avatar.url : nil
    json.views place.views.count
  end
end

