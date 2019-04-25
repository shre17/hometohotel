class CreateBringItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bring_items do |t|

      t.string :category
      t.string :name
      t.text :description
      t.integer :experience_id

      t.timestamps
    end
  end
end
