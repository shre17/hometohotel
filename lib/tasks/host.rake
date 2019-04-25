namespace :host do

  desc "TODO"

  dummy_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  task experiences: :environment do
    require 'faker'

    puts "Some fake Experiences"

    host = User.first.host

    location_data = {}
    cities = []
    i = 0
    (1..8).each do |i|
      address = Faker::Address.full_address.split(', ')

      location_data[i] = {}
      location_data[i][:city] = address.second
      location_data[i][:country] = address.last.split(' ').first
      location_data[i][:zipcode] = address.last.split(' ').last
      cities << address.second
      i += 1
    end

    # Dummy time range
    time_range = []
    time_frame = [12].push((1..11).map{ |i| i }).flatten
    list = %w(am pm).map{|time_f| time_frame.map{ |time| time.to_s + ':00 ' + time_f.upcase } }.flatten
    list.each_with_index{ |d,i| time_range << [d,i] }


    (1..50).map do |i|
      # Fake address
      address = Faker::Address.full_address.split(', ')
      street = address.first

      address = location_data[rand(1..8)]

      experience = host.experiences.create(city: cities.sample, category_1: Category.experiences.sample.id, category_2: Category.experiences.sample.id, title: "Title #{i}")

      experience.update(kick_off_experience: dummy_text, hospitality_mean_to_you: dummy_text, what_you_will_do: dummy_text, what_makes_you_qualified: dummy_text, additional_requirement: dummy_text, guest_money_benefits: dummy_text, where_you_will_be: dummy_text, nonprofit_organization_detail: dummy_text)

      experience.preferred_language = 'en'
      experience.organization_name = "Organization #{i}"
      experience.min_age = rand(1..9)
      experience.can_bring_kids_under_2_years = rand(0..1).to_i
      experience.max_group_size = rand(10..60)
      experience.price_per_guest = rand(100..999)
      experience.hosting_start_time = time_range
      experience.hosting_end_time = rand(6..24)
      experience.free_for_age_under_2_years = rand(0..1).to_i
      experience.latest_time_for_booking = Experience::LATEST_TIME_GUEST_CAN_BOOK.keys.sample


      # Fake Location
      location = experience.location.update(street: street, city: address[:city], country: address[:country], zipcode: address[:zipcode].to_i)

      experience.save

      (1..5).map do |data|
        # Dummy bring items
          item = experience.bring_items.new
          item.name = "#{data} Item to bring"
          item.description = dummy_text
          item.save

        # Dummy provide items
          item = experience.provide_items.new
          item.name = "#{data} Item we will provide"
          item.description = dummy_text
          item.save
      end
    end
    puts "done."
  end

  task places: :environment do
    require 'faker'

    puts "Some fake Places"

    host = User.first.host

    cities = []
    location_data = {}
    i = 0
    (1..8).each do |i|
      address = Faker::Address.full_address.split(', ')

      location_data[i] = {}
      location_data[i][:city] = address.second
      location_data[i][:country] = address.last.split(' ').first
      location_data[i][:zipcode] = address.last.split(' ').last
      cities << address.second
      i += 1
    end

    (1..50).map do |i|
      address = Faker::Address.full_address.split(', ')
      street = address.first

      address = location_data[rand(1..8)]

      place = host.places.create(category_id: Category.places.sample.id, name: "Place #{i}", description: dummy_text)

      place.property_type_id = place.category.property_types.pluck(:id).sample

      place.number_of_rooms = rand(2..6)
      place.what_will_guest_have = Place::GUEST_HAVE.sample
      place.dedicated_guest_space = Place::DEDICATED_GUEST_SPACE.keys.sample
      place.number_of_guests = rand(1..10)
      place.number_of_bedrooms = rand(1..4)
      place.number_of_beds = rand(place.number_of_bedrooms-1..place.number_of_bedrooms+1)
      place.private_bathroom = rand(place.number_of_bedrooms..place.number_of_bedrooms+1)
      place.check_in_date_from = Time.now.to_date-2.days
      place.check_in_date_to = Time.now.to_date+rand(50..200).days
      place.shared_spaces = Place::SPACES.keys.sample(2)
      place.advance_booking_period = Place::ADVANCE_BOOKING.keys.sample
      place.stay_upto_min = rand(1..3)
      place.stay_upto_max = rand(1..30)

      location = place.location.update(street: street, city: address[:city], country: address[:country], zipcode: address[:zipcode])

      place.save


      PropertyType.where(category_id: place.category_id).pluck(:title, :id)

      place.build_price(minimum: rand(100..400), maximum: rand(400..999), base_price: rand(100..900)).save
    end
    puts "done."
  end

end

# rake host:experiences
# rake host:places
