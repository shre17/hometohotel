class Price < ApplicationRecord
	belongs_to :place

  CURRENCY = %w(USD EUR JPY GBP AUD CAD CHF CNY SEK MXN NZD SGD SGD HKD NOK KRW TRY INR RUB BRL ZAR DKK PLN TWD THB MYR)

  def with_symbol
    Money.new((base_price || 1)*100, currency).format
  end

  def symbol_only
    Money.new(100, currency).format.first
  end
end
