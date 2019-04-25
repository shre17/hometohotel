class ChangeDataTypeOfPlacesColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :places, :check_in_time_from, :string
    change_column :places, :check_in_time_to, :string
  end
end
