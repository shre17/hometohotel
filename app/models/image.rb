class Image < ApplicationRecord
  # belongs_to :place
  mount_uploader :avatar, AvatarUploader
  belongs_to :imageable, polymorphic: true

  def avatar_image(type)
    avatar.present? ? avatar.url(type.to_sym) : '/assets/no-image.png'
  end
end
