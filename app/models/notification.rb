class Notification < AccountSetting

  def self.upcomming_booking
    reminder_prior_2_days
    reminder_for_tomorrow
    reminder_for_today
  end

  def self.write_a_review # Will send mail after 1 day of completion of booking
    get_bookings('-1').each do |booking|
      NotificationMailer.leave_a_review(booking).deliver_now if booking.user.permit_for_email?('reminder_email')
    end
  end

  def self.receive_message;end

  def self.booking_request;end

  def self.customer_support;end

  def self.changes_in_policy;end

  # Sub methods
  def self.reminder_prior_2_days
    get_bookings('+2').each do |booking|
      NotificationMailer.reminder_prior_2_days(booking).deliver_now if booking.user.permit_for_email?('reminder_email')
    end
  end

  def self.reminder_for_tomorrow
    get_bookings('+1').each do |booking|
      NotificationMailer.reminder_for_tomorrow(booking).deliver_now if booking.user.permit_for_email?('reminder_email')
    end
  end

  def self.reminder_for_today
    get_bookings('0').each do |booking|
      NotificationMailer.reminder_for_today(booking).deliver_now if booking.user.permit_for_email?('reminder_email')
    end
  end

  def self.get_bookings(diff)
    date =  case diff
              when '-1' then DateTime.now-1.day
              when '0' then DateTime.now
              when '+1' then DateTime.now+1.day
              when '+2' then DateTime.now+2.days
            end

    @bookings = Booking.where(end_date: (date.beginning_of_day..date.end_of_day))
    return @bookings
  end
end
