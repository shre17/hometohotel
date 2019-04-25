class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|

      t.string :title
      t.text :description
      t.boolean :status, default: true

      t.integer :place_id
      t.timestamps
    end
  end
end
