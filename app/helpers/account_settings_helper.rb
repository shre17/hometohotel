module AccountSettingsHelper

  def active_link?(link_name)
    case link_name
    when 'notification'
      (params['controller'].eql?('account_settings') && params['action'].eql?('edit')) ? 'active' : ''
    when 'security'
      (params['controller'].eql?('users/registrations') && params['action'].eql?('edit')) ? 'active' : ''
    when 'settings'
      (params['controller'].eql?('account_settings') && params['action'].eql?('settings')) ? 'active' : ''
    when 'bank_details'
      (params['controller'].eql?('bank_accounts') && params['action'].eql?('edit')) ? 'active' : ''
    end
  end
end
