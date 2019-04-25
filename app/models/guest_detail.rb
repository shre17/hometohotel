class GuestDetail < ApplicationRecord
  belongs_to :place, optional: true
end
