class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|

      t.string :name
      t.string :street
      t.string :apt
      t.string :city
      t.string :state
      t.string :country
      t.integer :zipcode
      t.float :latitude
      t.float :longitude
      t.string :address
      t.text :direction

      t.integer :locationable_id
      t.string  :locationable_type

      t.timestamps
    end
  end
end
