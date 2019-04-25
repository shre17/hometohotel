class Place < ApplicationRecord
  default_scope { order('created_at DESC') }
  belongs_to :host
  belongs_to :category, optional: true
  belongs_to :property_type, optional: true
  has_many :bedrooms, dependent: :destroy
  has_one :location, as: :locationable, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :guest_details, dependent: :destroy
  has_many :blocked_dates, as: :blockable, dependent: :destroy
  has_one :price, dependent: :destroy
  has_many :bookings, as: :bookable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :favourites, as: :favouritable, dependent: :destroy
  has_many :messages, as: :messagable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  # has_many :offers, as: :offerable
  has_and_belongs_to_many :offers, dependent: :destroy

  accepts_nested_attributes_for :bedrooms, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :rules, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :price, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :blocked_dates, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :offers, reject_if: :all_blank, allow_destroy: true

  # SPACES = {"1" => "Private living room", "2" => "Pool", "3" => "Kitchen", "4" => "Laundry-washer","5" =>  "Laundry-dryer", "6" => "Parking","7" =>  "Elevator","8" =>  "Hot tub", "9" => "Gym"}

  SPACES = {"1" => "Pool", "2" => "Cloths Washer", "3" => "Dryer", "4" => "Parking", "5" =>  "Elevator", "6" => "Gym", "7" =>  "Hot tub", "8" => "private sections for guest, living room, game room, work room, prayer room"
  }

  ROOMS = ["2-5","6-10","11-20","21-30", "31-40","41-50", "50+"].freeze

  GUEST_HAVE = [I18n.t('places.step_2.select_tag.option_1'), I18n.t('places.step_2.select_tag.option_2'), I18n.t('places.step_2.select_tag.option_3')]

  BEDROOMS = (1..11).map{ |b| ["#{b} #{(b==1 ? 'Bedroom' : 'Bedrooms')}", b] }

  GUEST_ARRIVAL = { "2" => "Same day", "24" => "1 day", "48" => "2 days", "72" => "3 days", "168" => "7 days" }

  DEDICATED_GUEST_SPACE = { 1 => "Yes, it’s primarily set up for guests", 0 => "No, I keep my personal belongings here"}

  ADVANCE_BOOKING = { "1" => "Any time", "90" => "3 months", "180" => "6 months", "270" => "9 months", "365" => "1 year", "0" => "Dates unavailable by default" }

  OTHER_BEDS = ["Couch","Bunk bed","Floor mattress","Air mattress","Crib","Toddler bed", "Hammock", "Water bed"]

  CURRENCY = ["USD","INR"]

  GUESTS = {}
  begin
    I18n.t('places.step_1.select_tag_2').each_with_index do |option, index|
      count = index +1
      GUESTS["#{count}"] = option[:option]
    end
  rescue
  end

  RENTED_BEFORE = {'0' => "I’m new to this",'1' => "I have"}
  GUEST_OFTEN = ["Not sure yet", "Part-time", "As often as possible"]

  GUEST_CHECKING = (1..11).map{|n| (n.to_s + " AM")} + ["12 PM Noon"] + (1..11).map{|n| (n.to_s+ " PM")} + ["12 AM Midnight"]

  FAMOUS_CITIES = ["Paris", "New York", "Sydney", "Cape Town", "Buenos Aires", "Seoul", "Barcelona", "Los Angeles"]

  POPULAR_CITIES = ["Chicago", "Los Angeles", "Miami", "New Mexico", "New York City", "Orlando", "San Francisco", "Seattle"]

  CHECK_IN_TIME = ["Flexible","8AM","9AM","10AM","11AM","12PM","1PM","2PM","3PM","4PM","5PM","6PM","7PM","8PM","9PM","10PM","11PM","12AM"]

  GUEST_CAN_BOOK_BEFORE = ["6AM","8AM","9AM","10AM","11AM","12PM(noon)","1PM","2PM","3PM","4PM","5PM","6PM","7PM","8PM","9PM","10PM","11PM", "12AM(midnight)"]

  IMAGES_RIGHT_NAME = {
    "ESSENTIALS- Towels, bed sheets, soap, toilet paper, and pillows" => "Essentials",
    "Wifi" => "Wifi",
    "Shampoo" => "Shampoo",
    "Closet-drawers" => "Closet-drawers",
    "TV" => "TV",
    "Heat" => "Heat",
    "Air-conditioning" => "Air-conditioning",
    "Laptop  Desk" => "Desk-workspace",
    "Fire Place" => "Fireplace",
    "Iron" => "Iron",
    "Hair Dryer" => "Hair-dryer",
    "Private Entrence" => "Private-entrance",
    "Breakfast-coffee-tea" => "Breakfast-coffee-tea"
  }

  after_create :add_an_location, :add_price
  after_create :set_default_rules
  after_create :set_user_role

  scope :with_city, -> { joins(:location).where.not('locations.city': nil) }
  scope :published, -> { where(published: true) }
  after_update :publish_resource

  def add_default_category
    self.category_id =Category.second.id
  end

  def author?(current_user)
    host.user == current_user
  end

  def get_amenities
    begin
      all_amenities = Amenity.find(amenities)
    rescue Exception => e
      puts e
    end
  end

  def get_safety_amenities
    Amenity.find(safety_amenities)
  end

  def get_cities
    location.try(:city)
  end

  def check_in_from
    self.check_in_date_from.to_date
  end

  def check_in_to
    self.check_in_date_to.to_date
  end

  def add_default_category
    self.category_id = Category.second.id if self.category_id.blank?
  end

  def reviewed_by_user?(user)
    return false if user.blank?
    reviews.where(user_id: user.id).present?
  end

  private
    def add_an_location
      self.build_location.save
    end

    def set_default_rules
      Rule.basic_rules.map{ |rule| self.rules.create(title: rule.title) }
    end

    def add_price
      self.build_price.save
    end

    def set_user_role
      host.user.add_role :host unless host.user.has_role?('host')
    end

    def publish_resource
      update(published: true) if (step.eql?(18) && !published?)
    end
end
