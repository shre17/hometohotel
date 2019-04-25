class AddVarifyProfileToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :profile_verified, :boolean
    rename_column :profiles, :verified, :mobile_verified
  end
end
