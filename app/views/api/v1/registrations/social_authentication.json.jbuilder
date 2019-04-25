json.status "success"
json.user do
  json.id @resource.id
  json.name @resource.profile.name
  json.email @resource.email
  json.auth_token @resource.auth_token
  json.facebook_uid @resource.facebook_uid
  json.google_oauth2_uid @resource.google_oauth2_uid
  json.deactivation_flag @resource.deactivation_flag
  json.selected_deactivation_reason @resource.selected_deactivation_reason
  json.detailed_reason_for_deactivation @resource.detailed_reason_for_deactivation
  json.email @resource.email
  json.bank_account_id @resource.host.bank_account.id
  json.image @resource.profile.image.url
end


