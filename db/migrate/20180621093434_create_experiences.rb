class CreateExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :experiences do |t|

      t.string :city
      t.boolean :hosted_an_experience
      t.text :kick_off_experience
      t.text :hospitality_mean_to_you
      t.string :preferred_language

      # Category
      t.string :category_1
      t.string :category_2
      t.boolean :this_is_a_concert
      t.boolean :nonprofit_organization
      t.boolean :organization_account
      t.boolean :is_food_the_main_theme
      t.boolean :is_alcohol_the_main_theme

      # Organization Detail
      t.string :organization_name
      t.boolean :have_consent_of_the_charitable_organization
      t.boolean :charitable_organization_meets_criteria
      t.text :nonprofit_organization_detail

      t.string :title
      t.text :what_makes_you_qualified
      t.text :what_you_will_do

      # has_one :location 
      # has_many :images

      t.text :where_you_will_be

      # has_many :provide_items
      # has_many :bring_items

      t.boolean :no_need_to_bring_anything, default: false
      t.text :must_know_before_booking
      t.boolean :no_additional_notes
      t.boolean :not_providing_anything
      t.boolean :i_confirm_that_description_and_photo_are_my_own

      # Settings
      # Add details like group size, price, default time, and more.

      t.integer :min_age
      t.boolean :can_bring_kids_under_2_years
      t.string :how_active_is_your_experience
      t.text :additional_requirement
      t.boolean :booker_to_verify_id
      t.integer :max_group_size
      t.integer :price_per_guest
      t.text :guest_money_benefits

      t.boolean :free_for_age_under_2_years
      t.string :hosting_start_time
      t.string :hosting_end_time
      t.integer :latest_time_for_booking
      t.boolean :experience_canceled_if_no_one_book
      t.boolean :my_experience_complies_with_local_laws
      t.boolean :i_agree_to_the_terms_of_service

      t.integer :step, default: 0

      t.float :rating
      t.integer :host_id

      t.timestamps
    end
  end
end
