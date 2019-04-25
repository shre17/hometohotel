class AddColumnIntoOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :host_id, :integer
  end
end
