class CreateJoinTablePlacesOffers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :places, :offers do |t|
      t.index [:place_id, :offer_id]
      t.index [:offer_id, :place_id]
    end
  end
end
