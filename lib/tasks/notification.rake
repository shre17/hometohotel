namespace :reminder do

  desc "TODO"

  task upcomming_booking: :environment do
    puts "Mail to users to inform about upcomming bookings"
    Notification.upcomming_booking
    puts "done."
  end

  task write_a_review: :environment do
    puts "Mail to ask users to write review about your visit and experience for the same."
    Notification.write_a_review
    puts "done."
  end
end

namespace :message do

  desc "TODO"

  task receive_message: :environment do
    puts "Mail to users to inform about upcomming bookings"
    Notification.receive_message
    puts "done."
  end

  task booking_request: :environment do
    puts "Mail to ask users to write review about your visit and experience for the same."
    Notification.booking_request
    puts "done."
  end
end

namespace :account_support do

  desc "TODO"

  task customer_support: :environment do
    puts "Mail by customer support to user, for their query"
    Notification.customer_support
    puts "done."
  end
end

namespace :policy_n_community do

  desc "TODO"

  task changes_in_policy: :environment do
    puts "Mail to users to inform them, regarding changes in policies of Homes2hotels"
    Notification.changes_in_policy
    puts "done."
  end
end
