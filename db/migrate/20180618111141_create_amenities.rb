class CreateAmenities < ActiveRecord::Migration[5.2]
  def change
    create_table :amenities do |t|
      t.string :title
      t.text :description
      t.boolean :amenity, default: false
      t.boolean :safety_amenity, default: false
      t.boolean :shared_spaces, default: false

      t.timestamps
    end
  end
end
