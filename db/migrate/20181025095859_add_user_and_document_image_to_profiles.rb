class AddUserAndDocumentImageToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :user_current_image, :string
  end
end
