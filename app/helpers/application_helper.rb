# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def example
    "e.g. \"#{link_to 'San Jose, CA', 'search/search_properties', :class => 'eg_city_state_post'}\", \"#{link_to 'New York, NY', 'search/search_properties', :class => 'eg_city_state_post'}\", \"#{link_to '95129', 'search/search_properties', :class => 'eg_zipcode_post'}\"..."
  end
  
  def search_button
    image_tag "search_button.png"
  end
end
