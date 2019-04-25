class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|

      # 1st Step (Place type)
      t.integer :category_id
      t.integer :property_type_id
      t.integer :number_of_rooms
      t.string :what_will_guest_have
      t.boolean :dedicated_guest_space

      # 2nd Step (Bedrooms)
      t.integer :number_of_guests
      t.integer :number_of_bedrooms
      t.integer :number_of_beds
      # has_many :bedrooms
      # has_many :beds

      # 3rd Step (Baths)
      t.integer :number_of_bathrooms
      t.boolean :private_bathroom

      # 4th Step (Location)
        # has_one :location

      # 5th Step (Amenities)
      t.string :amenities, array: true, default: '{}'
      # Fetch data from Amenities model for amenities: true
      t.string :safety_amenities, array: true, default: '{}'
      # Fetch data from Amenities model for safety_amenity: true

      # 6th 
      t.string :shared_spaces, array: true, default: '{}'
      # Fetch data from Amenities model for shared_spaces: true

      # Next steps
        # has_many :images

      t.string :name
      t.text :description
      t.integer :guest_arrives_notice
      t.string :check_in_date_from
      t.string :check_in_date_to
      t.integer :check_in_time_from
      t.integer :check_in_time_to
      t.integer :advance_booking_period
      t.integer :stay_upto_min
      t.integer :stay_upto_max

      # has_many :blocked_dates

      # has_one :price

      t.integer :host_id
      t.integer :step

      t.float :rating

      t.boolean :rented_out_your_place_before
      t.string :often_do_you_want_to_have_guests
      t.timestamps
    end
  end
end
