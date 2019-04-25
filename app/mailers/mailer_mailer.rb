class MailerMailer < ApplicationMailer

  def invitation
    @greeting = "Hi"

    mail to: "www.homes2hotels.com"
  end

  def notify_host(user,booking)
    @user = user
    @booking = booking
    mail(to: @booking.bookable.host.user.email, subject: 'New booking request!')   
  end
  
  def notify_user_about_cancellation(booking)
    @user = user
    @booking = booking
    mail(to: @booking.bookable.host.user.email, subject: 'New booking request!')      
  end

  def payment_sucessfull_mail(user,booking)
    @user = user
    @booking = booking
    mail(to: @user.email, subject: 'Booking status mail')
  end

end
