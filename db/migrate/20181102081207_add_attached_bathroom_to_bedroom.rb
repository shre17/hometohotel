class AddAttachedBathroomToBedroom < ActiveRecord::Migration[5.2]
  def change
    add_column :bedrooms, :no_of_attached_bathrooms, :integer, default: 0
    rename_column :places, :number_of_bathrooms, :number_of_common_bathrooms
  end
end
