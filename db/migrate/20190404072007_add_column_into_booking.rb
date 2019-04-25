class AddColumnIntoBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :accepted_by_host, :boolean
  end
end
