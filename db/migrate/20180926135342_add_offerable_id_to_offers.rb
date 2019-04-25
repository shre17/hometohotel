class AddOfferableIdToOffers < ActiveRecord::Migration[5.2]
  def up
    # remove_column :offers, :offerable_id, :integer
    # remove_column :offers, :offerable_type, :string
    change_column :offers, :active, :boolean, default: false
    add_column :places, :offer_id, :integer
  end

  def down
    change_column :offers, :active, :boolean, default: nil
  end
end
