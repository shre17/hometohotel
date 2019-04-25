class ChangeDefaultTypeIntoPlacesForBublished < ActiveRecord::Migration[5.2]
  def change
    change_column :places, :published, :boolean, default: false
  end
end
