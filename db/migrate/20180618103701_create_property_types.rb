class CreatePropertyTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :property_types do |t|

      t.string :title
      t.text :description
      t.integer :category_id

      t.timestamps
    end
  end
end
