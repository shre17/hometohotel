ActiveAdmin.register Profile do
  permit_params :verified
  show do
    attributes_table do
      row :title
      row :id
      row :name
      row :image
      row :city
      row :state
      row :country
      row :contact_no
      row :user_id
      row :school
      row :work
      row :string
      row :time_zone
      row :prefered_language
      row :prefered_currency
      row :date
      row :month
      row :first_name
      row :last_name
      row :gender
      row :email
      row :year
      row :languages
      row :describe_yourself
      row :work_email
      row :otp
      row :verified
      row :created_at
      row :updated_at
      row :user_current_image do |ad|
        link_to image_tag(ad.user_current_image.url, width: "100px", height: "100px"), ad.user_current_image.url
      end
      row :govt_id_soft_copy do |ad|
        link_to image_tag(ad.govt_id_soft_copy.url, width: "100px", height: "100px"), ad.govt_id_soft_copy.url
      end
      link_to "Varify"
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :list, :of, :attributes, :on, :model, :name, :image, :city, :state, :country, :contact_no, :school, :work, :string, :time_zone, :prefered_language, :prefered_currency, :date, :month, :first_name, :last_name, :gender, :email, :year, :languages, :describe_yourself, :work_email, :govt_id_soft_copy, :otp, :mobile_verified, :user_current_image, :profile_verified
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end

