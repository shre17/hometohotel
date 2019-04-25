class AddColumnChargesIntoBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :service_fee, :float
    add_column :bookings, :cleaning_fee, :float
    add_column :bookings, :tax, :float
    add_column :bookings, :final_price, :float
  end
end
