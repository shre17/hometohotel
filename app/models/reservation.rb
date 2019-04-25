class Reservation < ApplicationRecord
  belongs_to :booking
  after_create :send_notification_mail

  def purchase
    response = EXPRESS_GATEWAY.purchase(self.booking.price_in_cents, express_purchase_options)
    response.success?
  end

  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end

  private
    def express_purchase_options
      {
        :ip => ip,
        :token => express_token,
        :payer_id => express_payer_id
      }
    end

    def send_notification_mail
      NotificationMailer.new_booking_notification(self).deliver_now if booking.user.permit_for_email?('message_email')
    end
end
