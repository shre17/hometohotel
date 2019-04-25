json.status "success"
json.account_setting do
  json.id @account_setting.id
  json.message_email (@account_setting.message_email == nil ? false : @account_setting.message_email)
  json.message_push_notification (@account_setting.message_push_notification == nil ? false : @account_setting.message_push_notification)
  json.message_text_message (@account_setting.message_text_message == nil ? false : @account_setting.message_text_message)
  json.reminder_email (@account_setting.reminder_email == nil ? false : @account_setting.reminder_email)
  json.reminder_push_notification (@account_setting.reminder_push_notification == nil ? false : @account_setting.reminder_push_notification)
  json.reminder_text_message (@account_setting.reminder_text_message == nil ? false : @account_setting.reminder_text_message)
  json.promotion_and_tip_email (@account_setting.promotion_and_tip_email == nil ? false : @account_setting.promotion_and_tip_email)
  json.promotion_and_tip_push_notification (@account_setting.promotion_and_tip_push_notification == nil ? false : @account_setting.promotion_and_tip_push_notification)
  json.promotion_and_tip_text_message (@account_setting.promotion_and_tip_text_message == nil ? false : @account_setting.promotion_and_tip_text_message)
  json.promotion_and_tip_phone_call (@account_setting.promotion_and_tip_phone_call == nil ? false : @account_setting.promotion_and_tip_phone_call)
  json.policy_and_community_email (@account_setting.policy_and_community_email == nil ? false : @account_setting.policy_and_community_email)
  json.policy_and_community_push_notification (@account_setting.policy_and_community_push_notification == nil ? false : @account_setting.policy_and_community_push_notification)
  json.policy_and_community_text_message (@account_setting.policy_and_community_text_message == nil ? false : @account_setting.policy_and_community_text_message)
  json.policy_and_community_phone_call (@account_setting.policy_and_community_phone_call == nil ? false : @account_setting.policy_and_community_phone_call)
  json.account_support_email (@account_setting.account_support_email == nil ? false : @account_setting.account_support_email)
  json.account_support_push_notification (@account_setting.account_support_push_notification == nil ? false : @account_setting.account_support_push_notification)
  json.account_support_text_message (@account_setting.account_support_text_message == nil ? false : @account_setting.account_support_text_message)
end
