class Rule < ApplicationRecord
  belongs_to :place, optional: true

  scope :basic_rules, -> { where(place_id: nil)}
end
