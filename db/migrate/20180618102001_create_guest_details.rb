class CreateGuestDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :guest_details do |t|

      t.string :title
      t.text :description
      t.integer :place_id
      t.timestamps
    end
  end
end
