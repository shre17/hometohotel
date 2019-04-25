class ExperienceSerializer < ActiveModel::Serializer
  attributes :id,:city ,:hosted_an_experience, :kick_off_experience ,:hospitality_mean_to_you ,:preferred_language ,:category_1 ,:category_2 ,:this_is_a_concert ,:nonprofit_organization ,:organization_account ,:is_food_the_main_theme ,:is_alcohol_the_main_theme ,:organization_name ,:have_consent_of_the_charitable_organization ,:charitable_organization_meets_criteria ,:nonprofit_organization_detail ,:title ,:what_makes_you_qualified ,:what_you_will_do ,:where_you_will_be ,:no_need_to_bring_anything ,:must_know_before_booking ,:no_additional_notes ,:not_providing_anything ,:i_confirm_that_description_and_photo_are_my_own ,:min_age ,:can_bring_kids_under_2_years ,:how_active_is_your_experience ,:additional_requirement ,:booker_to_verify_id ,:max_group_size ,:price_per_guest ,:guest_money_benefits ,:free_for_age_under_2_years ,:hosting_start_time ,:hosting_end_time ,:latest_time_for_booking ,:experience_canceled_if_no_one_book ,:my_experience_complies_with_local_laws ,:i_agree_to_the_terms_of_service ,:step ,:rating ,:host_details , :photos, :total_reviews, :reviews, :location, :provide_items, :bring_items, :created_at ,:updated_at ,:curreny

  def host_details
    self.object.host.user.profile
  end

  def photos
    self.object.images
  end

  def total_reviews
    self.object.reviews.try(:count)
  end

  def reviews
    self.object.reviews.try(:first)
  end

  def location
    self.object.location
  end

  def provide_items
    self.object.provide_items
  end

  def bring_items
    self.object.bring_items
  end

  def category_1
    Category.find(self.object.category_1) rescue null
  end

  def category_2
    Category.find(self.object.category_2) rescue null
  end
end
