# Example:
#
# set :output, "/path/to/my/cron_log.log"

# Learn more: http://github.com/javan/whenever

# Running rake at different time to reduce the server load!

# In every 1 day
every 1.day, :at => '1am' do
  rake "reminder:upcomming_booking"
end

# In every 1 day
every 1.day, :at => '2am' do
  rake "reminder:write_a_review"
end

# In every 1 day
every 1.day, :at => '3am' do
  rake "message.receive_message"
end

# In every 1 day
every 1.day, :at => '4am' do
  rake "message.booking_request"
end
