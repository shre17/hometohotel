
unless @experiences.present?
  json.status "success"
  json.experiences @data do |data|
    json.count data[1].count
    json.city data[0]
    json.data data[1].first(4) do |experience|
      json.experience experience
      json.price experience.price_per_guest
      json.favourites experience.favourites.present?
      json.category Category.find(experience.category_1).title rescue nil
    end
  end
else
  json.status "success"
  json.city @experiences.first.location.city
  json.experiences @experiences do |experience|
    json.experience experience
    json.price experience.price_per_guest
  end
end

