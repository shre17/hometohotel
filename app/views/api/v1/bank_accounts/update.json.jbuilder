json.status "success"
# json.status   @status
# if @message.present?
#   json.message  @message
# end
json.bank_account do
  json.id @bank_account.id
  json.first_name @bank_account.first_name
  json.last_name @bank_account.last_name
  json.email @bank_account.email
  json.dob @bank_account.dob
  json.ssn @bank_account.ssn
  json.street @bank_account.street
  json.locality @bank_account.locality
  json.region @bank_account.region
  json.postal_code @bank_account.postal_code
  json.destination @bank_account.destination
  json.funding_email @bank_account.funding_email
  json.mobile_number @bank_account.mobile_number
  json.account_number @bank_account.account_number
  json.routing_number @bank_account.routing_number
  json.status @bank_account.status
  json.host_id @bank_account.host_id
  json.merchant_id @bank_account.merchant_id
end
