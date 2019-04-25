class Offer < ApplicationRecord
  # belongs_to :offerable, polymorphic: true
  has_and_belongs_to_many :experiences, dependent: :destroy
  has_and_belongs_to_many :places, dependent: :destroy
  belongs_to :host
end
