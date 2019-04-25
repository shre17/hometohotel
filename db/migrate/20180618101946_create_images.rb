class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|

      t.string :avatar
      t.text :description
      t.integer :imageable_id
      t.string  :imageable_type

      # t.integer :place_id
      # t.integer :experience_id

      t.timestamps
    end
  end
end
