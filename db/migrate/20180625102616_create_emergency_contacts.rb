class CreateEmergencyContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :emergency_contacts do |t|
      t.string :name
      t.bigint :phone
      t.string :email
      t.string :relationship
      t.integer :profile_id

      t.timestamps
    end
  end
end
