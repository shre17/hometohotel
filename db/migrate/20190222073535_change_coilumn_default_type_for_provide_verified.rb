class ChangeCoilumnDefaultTypeForProvideVerified < ActiveRecord::Migration[5.2]
  def change
    change_column :profiles, :profile_verified, :boolean, default: true
  end
end
