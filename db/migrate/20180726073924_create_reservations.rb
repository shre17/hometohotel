class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.integer :booking_id
      t.string :ip
      t.string :express_token
      t.string :express_payer_id
      t.boolean :success

      t.timestamps
    end
  end
end