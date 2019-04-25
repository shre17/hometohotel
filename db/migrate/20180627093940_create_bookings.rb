class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references :user, index: true, foreign_key: true
      # t.references :place, index: true, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.integer :price
      t.integer :total
      t.integer :offer
      t.integer :total_guest

      t.string :exp_date
      t.integer :exp_start_time
      t.integer :exp_end_time

      t.integer :exp_booking_date_id
      t.integer :bookable_id
      t.string :bookable_type
      t.string :exp_date
      t.integer :exp_start_time
      t.integer :exp_end_time
      t.boolean :payment_status, default: false
      t.string :currency

      t.timestamps
    end
  end
end
