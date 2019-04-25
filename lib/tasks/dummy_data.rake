namespace :dummy_data do

  desc "TODO"

  dummy_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  task favourites: :environment do
    puts "Dummy favourites added"
    User.all.each do |user|
      Experience.all.map{|exp| exp.favourites.create(user_id: user.id) }
      Place.all.map{|exp| exp.favourites.create(user_id: user.id) }
    end
    puts "done."
  end

  task reviews: :environment do
    puts "Dummy reviews added"
    User.all.each do |user|
      Experience.all.map do |exp|
        review = exp.reviews.new(user_id: user.id, content: dummy_text)
        review.accuracy = [1, 2, 3, 4, 5].sample
        review.amenities = [1, 2, 3, 4, 5].sample
        review.checkin = [1, 2, 3, 4, 5].sample
        review.communication = [1, 2, 3, 4, 5].sample
        review.cleanliness = [1, 2, 3, 4, 5].sample
        review.location = [1, 2, 3, 4, 5].sample
        review.service = [1, 2, 3, 4, 5].sample
        review.food_quality = [1, 2, 3, 4, 5].sample
        review.save
      end

      Place.all.map do |place|
        review = place.reviews.new(user_id: user.id, content: dummy_text)
        review.accuracy = [1, 2, 3, 4, 5].sample
        review.amenities = [1, 2, 3, 4, 5].sample
        review.checkin = [1, 2, 3, 4, 5].sample
        review.communication = [1, 2, 3, 4, 5].sample
        review.cleanliness = [1, 2, 3, 4, 5].sample
        review.location = [1, 2, 3, 4, 5].sample
        review.service = [1, 2, 3, 4, 5].sample
        review.food_quality = [1, 2, 3, 4, 5].sample
        review.save
      end
    end
    puts "done."
  end

  task bookings: :environment do
    puts "Dummy bookings for experience"
    Experience.all.each do |exp|
      (1..rand(2..5)).each do |i|
        exp.bookings.create(start_date: Time.now.to_date+rand(1..9).days, price: exp.price_per_guest, total_guest: rand(4..9), payment_status: true, user_id: User.all.sample.id)
      end
    end
    puts "done."
  end

  task missing_data: :environment do
    puts "Price per person for experience and place"
    User.all.each do |user|
      Experience.all.map do |exp|
        exp.price_per_guest = rand(100..900)
        exp.max_group_size = rand(10..50)
        exp.save
      end

      Place.all.map do |place|
        place.property_type_id = PropertyType.all.sample.id
        place.check_in_date_from = Time.now.to_date
        place.check_in_date_to = Time.now.to_date+rand(200..500).days
        place.number_of_rooms = rand(3..6)
        place.number_of_guests = place.number_of_rooms * rand(2..3)
        place.number_of_bedrooms = place.number_of_rooms - rand(1..3)
        place.number_of_beds = place.number_of_bedrooms
        # place.number_of_bathrooms = place.number_of_bedrooms + rand(1..3)
        place.private_bathroom = true

        place.price.minimum = rand(100..500)
        place.price.maximum = rand(500..999)
        place.price.base_price = (place.price.minimum + place.price.maximum)/2

        place.save
      end
    end
    puts "done."
  end
end

# rake dummy_data:favourites
# rake dummy_data:reviews
# rake dummy_data:bookings
# rake dummy_data:missing_data
