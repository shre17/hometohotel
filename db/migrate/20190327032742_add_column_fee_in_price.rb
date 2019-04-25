class AddColumnFeeInPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :prices, :service_fee, :float
    add_column :prices, :cleaning_fee, :float
    add_column :prices, :tax, :float
  end
end
