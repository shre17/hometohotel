class Booking < ApplicationRecord
  require 'money/bank/open_exchange_rates_bank'
  belongs_to :bookable, polymorphic: true
  belongs_to :user
  has_one :reservation, dependent: :destroy

  scope :confirmed_bookings, -> { where(payment_status: true) }
  
  # validates_presence_of :start_date, :end_date, :total_guest, :price, presence: true

  def accepted_or_rejected
    accepted_by_host ? 'Accepted' : 'Rejected'
  end

  def currency_conversion
    oxr = Money::Bank::OpenExchangeRatesBank.new
    oxr.app_id = '3d6ad0b63e304245b707710087172a21'
    oxr.update_rates
    @base_url = "https://openexchangerates.org/api/".freeze
    oxr.cache = URI.join(@base_url, 'latest.json')
    oxr.ttl_in_seconds = 86400
    oxr.date = '2015-01-01'
    # (currency == "USD") ? convert_to = "USD" : convert_to = "INR"
    oxr.source = currency
    oxr.show_alternative = true
    oxr.refresh_rates
    oxr.force_refresh_rate_on_expire = true
    Money.default_bank = oxr
    return Money.default_bank.get_rate(currency, "USD")
  end

  # def currency
  #   "USD"
  # end

  def stay_for_days
    (end_date - start_date).to_i/60/60/24 rescue 1
  end

  def price_in_cents
    converted_value = currency_conversion
    (total ? total * converted_value : price * converted_value) * 100
  end

  def merchant_id
    bookable.try(:host).try(:bank_account).try(:merchant_id)
  end

  def update_service_and_other_charges
    price_data = bookable.price
    self.cleaning_fee = calculate_percent_charge(total, price_data.cleaning_fee || 0)
    self.service_fee = calculate_percent_charge(total, price_data.service_fee || 0)
    self.tax = calculate_percent_charge(total, price_data.tax || 0)
    self.final_price = total + cleaning_fee + service_fee + tax
    self.save
  end

  def update_amount_for_all_guest
    self.final_price = self.total = price.to_f * total_guest.to_i
    self.save

  end

  def currency_symbol
    Money.new((1)*100, currency).format.first
  end

  def cleaning_fee_with_symbol
    Money.new((cleaning_fee || 0)*100, currency).format
  end

  def price_with_symbol
    Money.new((price || 0)*100, currency).format
  end

  def service_fee_with_symbol
    Money.new((service_fee || 0)*100, currency).format
  end

  def tax_with_symbol
    Money.new((tax || 0)*100, currency).format
  end

  def total_with_symbol
    Money.new((total || 0)*100, currency).format
  end

  def final_price_with_symbol
    Money.new((final_price || 0)*100, currency).format
  end

  def calculate_percent_charge(amount, percent)
    (amount.to_f*percent)/100
  end

  def start_date_in_date
    start_date.to_date
  end

  def end_date_in_date
    end_date.to_date
  end

  def exp_date_in_date
    exp_date.to_date
  end

  def is_experience?
    bookable.class.name.eql?("Experience")
  end

  def is_place?
    bookable.class.name.eql?("Place")
  end

  def exp_time
    "#{Time.parse("#{exp_start_time}:00").strftime("%l %P")} to #{Time.parse("#{exp_end_time}:00").strftime("%l %P")}"
  end
end