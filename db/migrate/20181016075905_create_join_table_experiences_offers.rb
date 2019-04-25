class CreateJoinTableExperiencesOffers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :experiences, :offers do |t|
      t.index [:experience_id, :offer_id]
      t.index [:offer_id, :experience_id]
    end
  end
end
