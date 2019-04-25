class Experience < ApplicationRecord
  belongs_to :host
  has_one :location, as: :locationable, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :favourites, as: :favouritable, dependent: :destroy
  has_many :items, as: :itemable, dependent: :destroy
  has_many :bring_items, dependent: :destroy
  has_many :provide_items, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :bookings, as: :bookable, dependent: :destroy
  has_many :messages, as: :messagable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  # has_many :offers, as: :offerable
  has_and_belongs_to_many :offers, dependent: :destroy

  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :bring_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :provide_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :offers, reject_if: :all_blank, allow_destroy: true

  after_create :add_an_location
  after_create :set_user_role
  after_update :publish_resource

  scope :with_city, -> { joins(:location).where.not('locations.city': nil) }
  scope :published, -> { where(published: true) }

  LANGUAGES =  { "de" => "Deutsch", "ca" => "Català", "en" => "English", "es" => "Español", "fr" => "Français", "it" => "Italiano", "pt" => "Português", "ru" => "Русский", "zh" => "中文 (简体)", "ja" => "日本語", "ko" => "한국어" }

  YOUR_EXPERIENCE = { "mostly_seated" => "Mostly seated", "light_walking" => "Light (e.g. a little walking)", "moderate" => "Moderate (e.g. a bike ride on mostly flat road)", "high" => "High (e.g. physical movement lasting more than an hour)", "strenuous" => "Strenuous (e.g. an uphill hike over rough terrain)" }

  LATEST_TIME_GUEST_CAN_BOOK = { "1" => "1 hour", "2" => "2 hours", "3" => "3 hours", "4" => "4 hours", "8" => "8 hours", "12" => "12 hours", "24" => "1 day", "48" => "2 days", "72" => "3 days", "96" => "4 days", "120" => "5 days", "144" => "6 days", "168" => "1 week" }

  def add_an_location
    self.build_location.save
  end

  def author?(current_user)
    host.user == current_user
  end
  
  def rating_text
    if rating.nil?
      'No rating present'
    elsif (rating > 4) then 'Superb'
    elsif (rating > 3) then 'Good'
    elsif (rating > 2) then 'Average'
    elsif (rating > 1) then 'Not so good'
    elsif (rating > 0) then 'Worst'
    end
  end

  def reviewed_by_user?(user)
    return false if user.blank?
    reviews.where(user_id: user.id).present?
  end

  def self.cities
    all.pluck(:city).uniq
  end

  def get_cities
    location.try(:city)
  end

  private
    def set_user_role
      host.user.add_role :host unless host.user.has_role?('host')
    end

    def publish_resource
      update(published: true) if (step.eql?(23) && !published?)
    end
end
