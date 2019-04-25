class Bedroom < ApplicationRecord
  belongs_to :place
  has_many :beds, dependent: :destroy
  accepts_nested_attributes_for :beds, reject_if: :all_blank, allow_destroy: true
end
