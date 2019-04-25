class CreateViews < ActiveRecord::Migration[5.2]
  def change
    create_table :views do |t|

      t.integer :no_of_time
      t.string :ip_address
      t.string :viewable_type
      t.string :viewable_id
      t.string :user_id
      t.timestamps
    end
  end
end
