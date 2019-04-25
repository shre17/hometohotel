class Message < ApplicationRecord
  belongs_to :messagable, polymorphic: true
  belongs_to :user
  belongs_to :received_by, class_name: 'User'

  after_create :send_notification_mail

  def sender_is?(current_user)
    self.user_id.eql?(current_user.id)
  end

  def receiver_image_url
    received_by.try(:profile).try(:image).try(:url)
  end

  def sender_image_url
    user.try(:profile).try(:image).try(:url)
  end

  def send_notification_mail
    NotificationMailer.new_message_notification(self).deliver_now if received_by.permit_for_email?('message_email')
  end

end
