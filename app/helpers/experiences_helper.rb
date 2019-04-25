module ExperiencesHelper

  def active_inactive_class(step)
    "#{@experience.step > step ? 'active' : ''} " + "#{@step == step ? 'current-active' : '' }"
  end

  def category_selected?
    Category.experiences.titles.include?(params[:category] || params[:city])
  end

  def check_price_range
    if params[:filter].present?
      price_from = params[:filter][:price].present? ? (params[:filter][:price][:minimum].blank? ? 50 : params[:filter][:price][:minimum].to_i) : 50
      price_to = params[:filter][:price].present? ? (params[:filter][:price][:maximum].blank? ? 900 : params[:filter][:price][:maximum].to_i) : 900
    else
      price_from = 10
      price_to = 1000
    end
    return price_from, price_to
  end

  def city_selected?
    Experience.cities.compact.include?(params[:city] || params[:category])
  end

  def set_path_for_city_n_category(data,type)
    if type.eql?(:city)
      if Category.experiences.titles.include?(params[:category])
        selected_city_and_category_path(data,params[:category])
      else
        selected_city_path(data)
      end
    elsif type.eql?(:category)
      if Experience.cities.compact.include?(params[:category])
        selected_city_and_category_path(params[:category],data)
      else
        selected_category_path(data)
      end
    end
  end

  def experience_category experience
    title = Category.find(experience.category_1).title
  end

  def sorted_hash_of_cities
    data = @experiences.group_by(&:city)
    data = data.sort_by{|k,v| v.count}.reverse
    return data
  end
end
