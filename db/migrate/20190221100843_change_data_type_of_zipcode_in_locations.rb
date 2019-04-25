class ChangeDataTypeOfZipcodeInLocations < ActiveRecord::Migration[5.2]
  def change
    change_column :locations, :zipcode, :string
  end
end
