module HostsHelper

  def host_offer_page?
    params[:controller].eql?("hosts") && params[:action].eql?('offers')
  end
end
