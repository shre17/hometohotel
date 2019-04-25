class CreateGuestProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :guest_profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :nationality
      t.string :passport_number
      t.integer :profile_id
      t.string :date
      t.string :year
      t.string :month
      t.timestamps
    end
  end
end
