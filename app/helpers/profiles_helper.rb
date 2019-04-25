module ProfilesHelper
  def get_lat_and_long(resources, type) 
    @data[type] = resources.collect {|c| {"latitude": c.location.latitude, "longitude": c.location.longitude}}
  end
end
