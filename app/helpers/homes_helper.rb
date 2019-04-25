module HomesHelper
  def top_rated_places_and_experiences
    @data = {}
    %w(Place Experience).each do |find_in|
      @data[find_in] = find_in.constantize.joins(:reviews, :location, :host).where('places.published': true).where('hosts.active': true).group_by(&:id) rescue {}
      @data[find_in] = @data[find_in].sort_by{|k,v| v.count}.reverse rescue {}
    end
    return @data
  end

  def total_places_and_experiences city
    data = {}
    %w(Place Experience).each do |find_in|
      data[find_in] = find_in.constantize.joins(:location).where(locations: {city: city.downcase})
    end
    return data
  end
end
