class ChangeDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :places, :rented_out_your_place_before, :string
  end
end
