class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|

      t.string :title
      t.boolean :place
      t.boolean :experience
      t.boolean :restaurent

      t.timestamps
    end
  end
end
