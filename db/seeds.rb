# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Add Property Categoy and Type
  #

  # as like airbnb
  # property_categories_n_types = { "Apartments" => ["Apartment", "Condominium", "Casa particular (Cuba)", "Loft", "Serviced apartment"], "House" => ["House (France)", "Cabin", "Casa", "particular (Cuba)", "Chalet", "Cottage", "Cycladic house", "Dammuso (Italy)", "Dome house", "Earth house", "Farm stay", "Houseboat", "Hut", "Lighthouse", "Pension (South Korea)", "Shepherd's hut (U.K.", "Tiny house", "Townhouse", "Trullo (Italy)", "Villa"], "Secondary units" => ["Guesthouse", "Guest suite", "Farm stay"], "Unique homes" => ["Barn", "Boat", "Bus", "Camper/RV", "Campsite", "Castle", "Cave", "Dome house", "Earth house", "farm stay", "Houseboat", "Hut", "Igloo", "Island", "Lighthouse", "Pension (South Korea)", "Plane", "Shepherd's hut (U.K., France)", "Tent", "Tiny house", "Tipi", "Train", "Treehouse", "Windmill", "Yurt"], "Bed and breakfasts" => ["Bed and breakfast", "Casa particular (Cuba)", "Farm stay", "Minsu (Taiwan)", "Nature lodge", "Ryokan (Japan)"], "Boutique hotels and more" => ["Boutique hotel", "Aparthotel", "Heritage hotel (India)", "Hostel", "Hotel", "Nature lodge", "Resort", "Serviced apartment"] }

  property_categories_n_types = { "Apartment" => ["Apartment", "Condominium", "House", "Loft"], "House" => ["House", "Cabin", "Chalet", "Cottage", "Houseboat", "Houseboat", "Hut", "Houseboat", "Hut", "Townhouse", "Villa"], "Other units" => ["Guest suite"], "A Bed and breakfast" => ["House", "Farm stay", "Nature lodge"], "Hotels, Hostels and more" => ["Hotel", "Hostel", "Resort", "Serviced apartment", "Vacation homes", "Luxury tents"] }

  property_categories_n_types.map do |category, types|
    @category = Category.where(place: true, title: category).first_or_create
    types.map{ |type| @category.property_types.where(title: type).first_or_create }
  end

# Add Categories for Experience

  experience_categories =  ["Arts & Design", "Fashion", "Entertainment", "Sports", "Wellness", "Nature", "Food & Drink", "Lifestyle", "History", "Music", "Business", "Nightlife"]

  experience_categories.map do |category, types|
    @category = Category.where(experience: true, title: category).first_or_create
  end

# Add Aminities
  Amenity.where(title: "ESSENTIALS- Towels, bed sheets, soap, toilet paper, and pillows", amenity: true, description: "Towels, bed, sheets, soap, toilet, paper and pillows").first_or_create

  # ["WIFI","SHAMPOO", "CLOSET-DRAWERS", "TV", "HEAT", "AIR CONDITIONING", "LAPTOP  DESK", "Breakfast-coffee-tea", "Desk-workspace", "FIRE PLACE","IRON", "HAIR DRYER", "Pets-in-the-house", "PRIVATE ENTRENCE"].map do |aminity|
  #   @amenity = Amenity.where(title: aminity, amenity: true).first_or_create
  # end

  ["Wifi","Shampoo", "Closet-drawers", "TV", "Heat", "Air-conditioning", "Laptop  Desk", "Fire Place","Iron", "Hair Dryer", "Private Entrence"].map do |aminity|
    @amenity = Amenity.where(title: aminity, amenity: true).first_or_create
  end

  # safety = ["Smoke detector","Carbon monoxide detector", "First aid kit", "Safety card", "Fire extinguisher","Lock on bedroom door"]

  safety = ["Smoke detector","First aid kit","Carbon monoxide detector"]


  desc =  ["Check your local laws, which may require a working smoke detector in every room","Check your local laws, which may require a working carbon monoxide detector in every room", "", "Posted emergency information and resources", "", "Private room can be locked for safety and privacy"]

  safety.zip(desc).each do |safe,descr|
    Amenity.where(title:safe, safety_amenity: true,  description: descr).first_or_create
  end

  # End Aminities

  # Add rules

  ["Suitable for children (2-12 years)", "Suitable for infants (Under 2 years)", "Suitable for pets", "Smoking allowed", "Events or parties allowed"].each do |rule|
    Rule.where(title: rule).first_or_create
  end

  ["Must climb stairs", "Potential for noise", "Pet(s) live on property", "No parking on property", "Some spaces are shared", "Amenity limitations", "Surveillance or recording devices on property", "Weapons on property", "Dangerous animals on property"].each do |detail|
    GuestDetail.where(title: detail).first_or_create
  end

  # Create Languages
  Profile::LANGUAGES.collect {|c| Language.create(name: c)}

  #Create Offers
  (1..3).each do |n|
    Offer.where(:title => "Offer #{n*10}% off to your first guests ",:description => "The first 3 guests who book your place will get #{n*10}% off their stay. This special offer can attract new guests, and help you get the 3 reviews you need for a star rating.",:discount => n*10).first_or_create
  end

# rake db:seed
# Create some Users 4-5
# rake host:experiences
# rake host:places
# rake dummy_data:favourites
# rake dummy_data:reviews
# rake dummy_data:missing_data
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')