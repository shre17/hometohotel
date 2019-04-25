class AddColumnIntoHost < ActiveRecord::Migration[5.2]
  def change
    add_column :hosts, :active, :boolean, default: false 
  end
end
