class Category < ApplicationRecord
  has_many :property_types, dependent: :destroy
  scope :places, -> { where(place: true) }
  scope :experiences, -> { where(experience: true) }
  scope :restaurents, -> { where(restaurent: true) }

  def self.titles
    pluck(:title)
  end
end
