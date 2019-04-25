json.status "success"
json.profile do
 json.id @profile.id
 json.name @profile.name
 json.image @profile.image
 json.first_name @profile.first_name
 json.last_name @profile.last_name
 json.gender @profile.gender
 json.date @profile.date
 json.month @profile.month
 json.year @profile.year
 json.languages @profile.languages
 json.prefered_language @profile.prefered_language
 json.prefered_currency @profile.prefered_currency
 json.city @profile.city
 json.country @profile.country
 json.string @profile.string
 json.user_id @profile.user_id
 json.describe_yourself @profile.describe_yourself
 json.work_email @profile.work_email
 json.mobile_verified @profile.mobile_verified
 json.otp @profile.otp
 json.user_current_image @profile.user_current_image
 json.profile_verified @profile.profile_verified
 json.created_at @profile.created_at
 json.updated_at @profile.updated_at
 json.email @profile.email
 json.contact_no @profile.contact_no
 json.work @profile.work
 json.govt_id_soft_copy @profile.govt_id_soft_copy
 json.time_zone @profile.time_zone
 json.vat_number @profile.vat_number
 json.emergency_contact @profile.emergency_contact
 json.school @profile.school
end

