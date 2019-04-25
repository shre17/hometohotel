class ChangeHostActiveColumnToDefaultTrue < ActiveRecord::Migration[5.2]
  def change
    change_column :hosts, :active, :boolean, default: true
  end
end
