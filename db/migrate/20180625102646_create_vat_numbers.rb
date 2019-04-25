class CreateVatNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :vat_numbers do |t|
      t.string :member_state
      t.integer :vat_number
      t.string :vat_name
      t.text :vat_address_line_1
      t.text :vat_optional_address_line_2
      t.string :vat_city
      t.string :vat_state
      t.string :vat_zip
      t.text :verification_msg
      t.integer :profile_id

      t.timestamps
    end
  end
end
