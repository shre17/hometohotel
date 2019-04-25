class ChangeDefaultTypeOfPublishedFieldOfPlace < ActiveRecord::Migration[5.2]
  def change
    change_column :places, :published, :boolean, default: true
  end
end
