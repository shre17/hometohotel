class RemoveColumnIntoOffer < ActiveRecord::Migration[5.2]
  def change
    remove_column :offers, :place_id
  end
end
