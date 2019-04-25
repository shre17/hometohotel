class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :sender, :receiver, :messagable_type, :messagable_id, :created_at, :updated_at, :status

  def sender
    object.user.profile
  end

  def receiver
    object.received_by
  end

  def status
    "success"
  end
end
