class BankAccount < ApplicationRecord
  belongs_to :host

  validates_presence_of :first_name, :last_name, :email, :dob, :ssn, :street, :locality, :region, :postal_code, :funding_email, :mobile_number, :account_number, :routing_number, presence: true
end
