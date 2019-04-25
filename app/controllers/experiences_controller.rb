class ExperiencesController < ApplicationController
  include FilterController

  before_action :set_host, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_experience, only: [:edit, :update, :destroy]
  before_action :get_experience, only: [:show]
  before_action :set_category, only: [:index]

  def index
    grab_experiences_based_on_selected_city_and_state
    filter_experiences_data if filter_params.present?
  end

  def show;end

  def new
    begin
      @experience = @host.experiences.new
      @experience.build_location
    rescue Exception => e
      puts e
    end
  end

  def edit;end

  def create
    @experience = @host.experiences.new(experience_params)

    respond_to do |format|
      if @experience.save
        format.html { redirect_to edit_experience_path(@experience), notice: 'Experience was successfully created.' }
        format.json { render :show, status: :created, location: @experience }
      else
        format.html { render :new }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    redirect_path = if @experience.update(experience_params)
                      if (params[:step] || @experience.step).to_i >= 23
                        @experience
                      elsif params[:step].present?
                        edit_experience_path(@experience, step: params[:step])
                      else
                        edit_experience_path(@experience)
                      end
                    else
                      edit_experience_path(@experience)
                    end
    redirect_to redirect_path, notice: 'Experience was successfully updated.'
  end

  def destroy
    @experience.destroy
    respond_to do |format|
      format.html { redirect_to experiences_url, notice: 'Experience was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def grab_experiences_based_on_selected_city_and_state
    @experiences = Experience.includes(:location, :host).where('experiences.published': true).where('hosts.active': true)
    @experiences =  if (params[:city].present? && params[:category].present?)
                      @experiences.where("category_1 = ? OR category_2 = ?", @category.id.to_s, @category.id.to_s).where(city: params[:city])
                    elsif @category.present?
                      @experiences.where("category_1 = ? OR category_2 = ?", @category.id.to_s, @category.id.to_s)
                    elsif params[:category].present?
                      @experiences.where(city: (params[:city] || params[:category]))
                    else
                      @experiences
                    end
  end

  def confirm_booking
  end

  def delete_item
    params[:item].constantize.find(params[:id]).delete
    render json: {id: params[:id]}
  end

  private
    def get_experience
      @experience = Experience.find(params[:id])
      @similar_listing = Experience.where("id != ? and city = ? and rating >= ?", params[:id], @experience.city, @experience.rating).first(16)
    end

    def set_host
      @host = current_user.host
    end

    def set_experience
      @experience = @host.experiences.find(params[:id])
    end

    def set_category
      @category = Category.find_by_title(params[:category])
    end

    def experience_params
      return ({}) if params[:experience].blank?
      params.require(:experience).permit(:curreny,:city, :hosted_an_experience, :kick_off_experience, :hospitality_mean_to_you, :preferred_language,
       :category_1, :category_2, :is_food_the_main_theme, :is_alcohol_the_main_theme, :no_need_to_bring_anything,
       :title, :nonprofit_organization, :organization_account, :organization_name, :this_is_a_concert, :nonprofit_organization_detail, :what_makes_you_qualified, :what_you_will_do, :where_you_will_be, :must_know_before_booking, :no_additional_notes, :min_age, :can_bring_kids_under_2_years, :how_active_is_your_experience, :additional_requirement, :booker_to_verify_id, :max_group_size, :price_per_guest, :free_for_age_under_2_years, :guest_money_benefits, :hosting_start_time, :hosting_end_time, :latest_time_for_booking, :experience_canceled_if_no_one_book, :my_experience_complies_with_local_laws, :i_agree_to_the_terms_of_service, :i_confirm_that_description_and_photo_are_my_own, :step, :have_consent_of_the_charitable_organization, :charitable_organization_meets_criteria, :not_providing_anything,
        location_attributes: [:id, :name, :street, :apt, :city, :state, :country, :zipcode, :latitude, :longitude, :address, :direction, :_destroy],
        provide_items_attributes: [:id, :category, :name, :description, :is_alcohol, :compliance_with_local_alcohol_laws, :provide, :_destroy],
        bring_items_attributes: [:id, :category, :name, :description, :is_alcohol, :compliance_with_local_alcohol_laws, :bring, :_destroy],
        images_attributes: [:id, :avatar, :description, :_destroy])
    end
end
