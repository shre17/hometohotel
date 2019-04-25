class AddIsCreatedToPlaces < ActiveRecord::Migration[5.2]
  def change
  	add_column :places, :is_created, :boolean, :default => false
  end
end
