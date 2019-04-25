class NotificationMailer < ApplicationMailer

  def reminder_prior_2_days(booking)
    subject = 'Prior Notification'
    mail(to: booking.user.email, subject: subject)
  end

  def reminder_for_tomorrow(booking)
    subject = 'You have a booking for Tomorrow'
    mail(to: booking.user.email, subject: subject)
  end

  def reminder_for_today(booking)
    subject = 'You have a booking for Today'
    mail(to: booking.user.email, subject: subject)
  end

  def leave_a_review(booking)
    subject = 'How was your experience, leave a review'
    mail(to: booking.user.email, subject: subject)
  end

  def new_message_notification(message)
    @receiver = message.received_by
    @sender = message.user

    subject = "New message received by #{@sender.name}"
    mail(to: @receiver.email, subject: subject)
  end

  def new_booking_notification(reservation)
    @booking = reservation.booking
    @host = reservation.booking.bookable.host
    @user = reservation.booking.user

    subject = "New booking request arrived for your #{reservation.bokking.bookable.class.name}"
    mail(to: @host.email, subject: subject)
  end

end

