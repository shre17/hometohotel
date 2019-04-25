class CreateBedrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :bedrooms do |t|

      t.boolean :common_space, default: false
      t.integer :total_beds
      t.integer :place_id
      t.timestamps
    end
  end
end
