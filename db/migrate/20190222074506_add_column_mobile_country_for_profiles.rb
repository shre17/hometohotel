class AddColumnMobileCountryForProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :mobile_country, :string
  end
end
