json.status "success"
json.profile do
 json.id @profile.id
 json.govt_id_soft_copy @profile.govt_id_soft_copy.url
 json.user_current_image @profile.user_current_image.url
end
