class AddColumnIntoPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :status, :string, default: 'pending'
    add_column :places, :published, :boolean, default: false
    add_column :experiences, :status, :string, default: 'pending'
    add_column :experiences, :published, :boolean, default: false
  end
end
