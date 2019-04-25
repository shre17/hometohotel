class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :content, :overall_rating, :user_name, :created_at, :updated_at

  def user_name
    object.user.profile.name
  end
end
