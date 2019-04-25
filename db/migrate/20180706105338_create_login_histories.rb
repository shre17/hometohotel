class CreateLoginHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :login_histories do |t|
      t.integer :user_id
      t.string :browser
      t.string :device_type
      t.string :city
      t.string :region
      t.string :last_sign_in_at

      t.timestamps
    end
  end
end
