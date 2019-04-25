class Host < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :offers, dependent: :destroy
  # has_many :offers, as: :offerable
  has_one :bank_account, dependent: :destroy

  rolify

  after_create :add_bank_account

  def add_bank_account
    build_bank_account.save(validate: false)
  end
end
