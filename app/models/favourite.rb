class Favourite < ApplicationRecord
  belongs_to :favouritable, polymorphic: true
  belongs_to :user
  scope :for_experience, -> { where(favouritable_type: 'Experience') }
  scope :for_place, -> { where(favouritable_type: 'Place') }
end
