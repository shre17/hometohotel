module Api::V1
  class ExperiencesController < BaseApiController
    def index
      data = Experience.with_city.group_by(&:get_cities)
      data = data.sort_by{|k,v| v.count}.reverse
      @data = data.first(4)
      @experiences = Experience.joins(:location).where(:locations => {:city => params[:city]})if params[:city].present?
    end

    def show
      begin
        @experience = Experience.find(params[:id])
        similar_experience
        @status = 'success'
      rescue
        @experience = nil
        @status = 'error'
      end
      render json: { status: @status, experience: (@experience.present? ? ExperienceSerializer.new(@experience) : nil), similar_experiences: @similar_experience }
    end

    def similar_experience
      @similar_experience = Experience.where.not(id: @experience.id).joins(:location).where(locations: {city: @experience.location.city})
      query = ["rating >= ?", @experience.rating]
      @similar_experience = @similar_experience.where(query)
    end
  end
end
