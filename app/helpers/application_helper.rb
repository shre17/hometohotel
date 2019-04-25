module ApplicationHelper

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def footer_required?
    (%w(experiences places).include?(params[:controller]) && %w(new edit).include?(params[:action]))
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def resource_name
    :user
  end

  def is_mobile_request?
    request.user_agent =~ /Mobile|webOS/
  end

  def options_for_select_field(data)
    data.map{ |k,v| [v,k] }
  end

  def sort_hash(data)
    data.sort_by {|_key, value| value}.to_h
  end

  def time_list
    data = []
    time_frame = [12].push((1..11).map{ |i| i }).flatten
    list = %w(am pm).map{|time_f| time_frame.map{ |time| time.to_s + ':00 ' + time_f.upcase } }.flatten
    list.each_with_index{ |d,i| data << [d,i] }
    return data
  end

  def flash_class(level)
    case level.to_s
        when 'notice' then "alert alert-dismissable alert-info"
        when 'success' then "alert alert-dismissable alert-success"
        when 'error' then "alert alert-dismissable alert-danger"
        when 'alert' then "alert alert-dismissable alert-danger"
    end
  end
end
