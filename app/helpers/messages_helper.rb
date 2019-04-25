module MessagesHelper
  def host_detail message
    user = message.messagable.host.user
  end

  def customer_detail conversation
    customer = User.find((conversation.collect(&:user_id) - [host_detail(conversation.first).id]).first)
  end

  def booking_detail conversation
    @booking = conversation.first.messagable.bookings.where(user_id: customer_detail(conversation).id).last
  end

  def messenger_id(message,contacted_user_id)
    if @messages.collect(&:user_id).uniq.length.eql?(1)                    
      if message.sender_is?(current_user)
        message.received_by_id
      else 
        message.user_id
      end
    else
      contacted_user_id
    end
  end

  def message_attribute(message,contacted_user_id,attr)
    if @messages.collect(&:user_id).uniq.length.eql?(1)
      if message.sender_is?(current_user)
        message.received_by.profile.send("#{attr}")
      else
        message.user.profile.send("#{attr}")
      end
    else
      User.find(contacted_user_id).profile.send("#{attr}")
    end
  end

  def readable_date_format(date)
    date.strftime("%a, %dth %b")
  end


  def time_calculation message
    distance_of_time_in_words(message.created_at, Time.now)
  end
end
