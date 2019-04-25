class GuestProfile < ApplicationRecord
  belongs_to :profile

  DATE = 1..31
  YEAR = 2018..2038
  MONTH = 1..12
end
