class AddColumnIntoReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :braintree_transaction_id, :string
  end
end
