class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :image
      t.string :city
      t.string :state
      t.string :country
      t.bigint :contact_no
      t.integer :user_id
      t.string :school
      t.string :work
      t.datetime :string
      t.string :time_zone

      t.string :prefered_language
      t.string :prefered_currency
      t.string :date
      t.string :month
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :email
      t.string :year
      t.string :languages, array: true, default: '{}'
      t.text :describe_yourself
      t.string :work_email
      t.string :govt_id_soft_copy
      t.string :otp
      t.boolean :verified
      t.timestamps
    end
  end
end
