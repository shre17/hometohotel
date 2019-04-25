class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :message
      t.integer :user_id
      t.integer :received_by_id
      t.string :messagable_type
      t.integer :messagable_id
      t.timestamps
    end
  end
end
