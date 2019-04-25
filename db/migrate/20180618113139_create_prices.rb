class CreatePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :prices do |t|

      t.float :minimum
      t.float :maximum
      t.float :base_price
      t.string :currency

      t.integer :place_id
      t.timestamps
    end
  end
end
