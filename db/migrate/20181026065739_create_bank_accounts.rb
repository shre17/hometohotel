class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :dob
      t.string :ssn
      t.string :street
      t.string :locality
      t.string :region
      t.integer :postal_code
      t.string :destination
      t.string :funding_email
      t.bigint :mobile_number
      t.string :account_number
      t.string :routing_number
      t.string :status
      t.integer :host_id
      t.string :merchant_id

      t.timestamps
    end
  end
end
