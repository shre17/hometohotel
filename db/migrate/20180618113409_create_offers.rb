class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|

      t.string :title
      t.text :description
      t.integer :discount
      t.integer :weekly_discount
      t.integer :monthly_discount
      t.decimal :max_discount
      t.boolean :active

      t.integer :place_id
      t.timestamps
    end
  end
end
