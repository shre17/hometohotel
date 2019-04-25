class Item < ApplicationRecord
  belongs_to :itemable, polymorphic: true

  CATEGORY = %w(Meal Accommodations Tickets Transportation Equipment Snacks)
  PROVIDE_CATEGORY = %w(Meal Drink Tickets Transportation Equipment Snacks)
end
