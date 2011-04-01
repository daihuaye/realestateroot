class SearchController < ApplicationController
  
  def search_properties
    search_obj = params[:search]
    query = {:zip => "", :city => "", :state => "", :state_des => ""}
    if !search_obj.blank? && !search_obj[:search_text].blank? && !options?(search_obj)
      is_valid = populate_query(search_obj[:search_text], query)
      @search_trulia_text = format_trulia_str(is_valid, search_obj[:search_text], query) if search_obj[:trulia]
      @search_zillow_text = format_zillow_str(search_obj[:search_text]) if search_obj[:zillow]
      @search_yahoo_text = format_yahoo_str(is_valid, search_obj[:search_text], query) if search_obj[:yahoo]
      @search_realtor_text = format_realtor_str(is_valid, query) if search_obj[:realtor]
      @search_century21_text = format_century21_str(is_valid, search_obj[:search_text], query) if search_obj[:century21]
      @search_homes_text = format_homes_str(is_valid, query) if search_obj[:homes]
    elsif !search_obj.blank? && !search_obj[:search_text].blank? && options?(search_obj)
      options = format_options(search_obj)
      is_valid = populate_query(search_obj[:search_text], query)
      @search_zillow_text = format_zillow_str_with_option(search_obj, options) if search_obj[:zillow]
      @search_trulia_text = format_trulia_str_with_option(is_valid, search_obj[:search_text], options, query) if search_obj[:trulia]
      @search_yahoo_text = format_yahoo_str_with_option(is_valid, search_obj[:search_text], options, query) if search_obj[:yahoo]
      @search_realtor_text = format_realtor_str_with_option(is_valid, options, query) if search_obj[:realtor]
      @search_century21_text = format_century21_str_with_option(is_valid, search_obj[:search_text], options, query) if search_obj[:century21]
      @search_homes_text = format_homes_str_with_option(is_valid, options, query) if search_obj[:homes]
    end
    respond_to do |format|
      format.html {redirect_to "/"}
      format.js
    end
  end
  
  def get_url_text
    search_obj = params[:search]
    @site = params[:site]
    puts "this is site: #{@site}"
    query = {:zip => "", :city => "", :state => "", :state_des => ""}
    if !search_obj.blank? && !search_obj[:search_text].blank? && !options?(search_obj)
      is_valid = populate_query(search_obj[:search_text], query)
      case @site
        when "trulia"
          @search_trulia_text = format_trulia_str(is_valid, search_obj[:search_text], query)
        when "zillow"
          @search_zillow_text = format_zillow_str(search_obj[:search_text])
        when "homes"
          @search_homes_text = format_homes_str(is_valid, query)
        when "yahoo"
          @search_yahoo_text = format_yahoo_str(is_valid, search_obj[:search_text], query)
        when "realtor"
          @search_realtor_text = format_realtor_str(is_valid, query)
        when "century21"
          @search_century21_text = format_century21_str(is_valid, search_obj[:search_text], query)
      end
    elsif !search_obj.blank? && !search_obj[:search_text].blank? && options?(search_obj)
      options = format_options(search_obj)
      is_valid = populate_query(search_obj[:search_text], query)
      case params[:site]
        when "trulia"
          @search_trulia_text = format_trulia_str_with_option(is_valid, search_obj[:search_text], options, query)
        when "zillow"
          @search_zillow_text = format_zillow_str_with_option(search_obj, options)
        when "homes"
          @search_homes_text = format_homes_str_with_option(is_valid, options, query)
        when "yahoo"
          @search_yahoo_text = format_yahoo_str_with_option(is_valid, search_obj[:search_text], options, query)
        when "realtor"
          @search_realtor_text = format_realtor_str_with_option(is_valid, options, query)
        when "century21"
          @search_century21_text = format_century21_str_with_option(is_valid, search_obj[:search_text], options, query)
      end
      
    end
    respond_to do |format|
      format.html {redirect_to "/"}
      format.js
    end
  end
  
  private
  
  def options?(obj)
    if obj[:min_price].eql?("$0") && obj[:max_price].eql?("$100,000,000") && obj[:bath_room].eql?("1+") && obj[:bed_room].eql?("1+")
      return false
    else
      return true
    end
  end
  
  def format_homes_str(is_valid, query)
    if is_valid
      if !query[:zip].blank?
        homes_text = "Content/Inter.cfm?PropType=&MinPrice=&MaxPrice=&Bedrooms=&Fullbaths=&ZipCode=#{query[:zip]}"
      else
        homes_text = "Content/Inter.cfm?PropType=&MinPrice=&MaxPrice=&Bedrooms=&Fullbaths=&City=#{query[:city]}&State=#{query[:state]}"
      end
    else
      homes_text = print_homes_error
    end
  end
  
  def format_zillow_str(str)
    zillow_text = str
    zillow_text = zillow_text.gsub(/\ /, "-")
    zillow_text = "#{zillow_text}_rb"
  end
  
  def format_realtor_str(is_valid, query)
    if is_valid
      if !query[:zip].blank?
        realtor_text = "realestateandhomes-search/#{query[:zip]}"
      else
        realtor_text = "realestateandhomes-search/#{query[:city].downcase.titlecase.gsub(/\ /, "-")}_#{query[:state]}"
      end
    else
      realtor_text = print_realtor_error
    end
  end
  
  def format_yahoo_str(is_valid, str, query)
    if is_valid
      if !query[:zip].blank?
        yahoo_text = "search/#{query[:state_des].downcase.titlecase.gsub(/\ /, "_")}/#{query[:city].downcase.titlecase.gsub(/\ /, "_")}/homes-for-sale?typeBak=realestate&p=#{query[:zip]}&type=classified&priceLow=&priceHigh=&bedroomLow=&bathroomLow=&search=Search"
      else
        yahoo_text = "search/#{query[:state_des].downcase.titlecase.gsub(/\ /, "_")}/#{query[:city].downcase.titlecase.gsub(/\ /, "_")}/homes-for-sale?typeBak=realestate&p=#{query[:city].strip.gsub(/\ /, "+")}%2C+#{query[:state]}&type=classified&priceLow=&priceHigh=&bedroomLow=&bathroomLow=&search=Search"
      end
    else
      yahoo_text = print_yahoo_error(str)
    end
  end
  
  def format_century21_str(is_valid, str, query)
    if is_valid
      if !query[:zip].blank?
        century21_text = "realestatesearch/#{query[:zip]}?svf=lsp&q=&where=&where=&where=&where=&x=0&y=0&proximity=&minprice=&maxprice=&minbeds=&maxbeds=&minbaths=&maxbaths=&minsqft=&maxsqft="
      else
        century21_text = "realestatesearch/#{query[:city]}-#{query[:state]}?svf=lsp&q=&where=&where=&where=&where=&x=0&y=0&proximity=&minprice=&maxprice=&minbeds=&maxbeds=&minbaths=&maxbaths=&minsqft=&maxsqft="
      end
    else
      century21_text = print_century21_error(str)
    end
  end
  
  def format_homes_str_with_option(is_valid, options, query)
    if is_valid
      if !query[:zip].blank?
        homes_text = "Content/Inter.cfm?PropType=&MinPrice=#{options[:min_price]}&MaxPrice=#{options[:max_price]}&Bedrooms=#{options[:bed_room]}+&Fullbaths=#{options[:bath_room]}+&ZipCode=#{query[:zip]}"
      else
        homes_text = "Content/Inter.cfm?PropType=&MinPrice=#{options[:min_price]}&MaxPrice=#{options[:max_price]}&Bedrooms=#{options[:bed_room]}+&Fullbaths=#{options[:bath_room]}+&City=#{query[:city].upcase}&State=#{query[:state]}"
      end
    else
      realtor_text = print_realtor_error
    end
  end
  
  def format_century21_str_with_option(is_valid, str, options, query)
    if is_valid
      if !query[:zip].blank?
        century21_text = "realestatesearch/#{query[:zip]}?svf=lsp&q=&where=&where=&where=&where=&x=0&y=0&proximity=&minprice=#{options[:min_price]}&maxprice=#{options[:max_price]}&minbeds=#{options[:bed_room]}&maxbeds=&minbaths=#{options[:bath_room]}&maxbaths=&minsqft=&maxsqft="
      else
        century21_text = "realestatesearch/#{query[:city]}-#{query[:state]}?svf=lsp&q=&where=&where=&where=&where=&x=0&y=0&proximity=&minprice=#{options[:min_price]}&maxprice=#{options[:max_price]}&minbeds=#{options[:bed_room]}&maxbeds=&minbaths=#{options[:bath_room]}&maxbaths=&minsqft=&maxsqft="
      end
    else
      century21_text = print_century21_error(str)
    end
  end
  
  def format_realtor_str_with_option(is_valid, options, query)
    if is_valid
      if !query[:zip].blank?
        realtor_text = "realestateandhomes-search/#{query[:zip]}/beds-#{options[:bed_room]}/baths-#{options[:bath_room]}/price-#{options[:min_price]}-#{options[:max_price]}"
      else
        realtor_text = "realestateandhomes-search/#{query[:city].downcase.titlecase.gsub(/\ /, "-")}_#{query[:state]}/beds-#{options[:bed_room]}/baths-#{options[:bath_room]}/price-#{options[:min_price]}-#{options[:max_price]}"
      end
    else
      realtor_text = print_realtor_error
    end
  end
  
  def format_zillow_str_with_option(obj, options)
    zillow_text = format_zillow_str(obj[:search_text])
    zillow_text = "#{zillow_text}/#{options[:min_price]}-#{options[:max_price]}_price/#{options[:bath_room]}-_baths/#{options[:bed_room]}-_beds"
  end
  
  def format_yahoo_str_with_option(is_valid, str, options, query)
    if is_valid
      if !query[:zip].blank?
        yahoo_text = "search/#{query[:state_des].downcase.titlecase.gsub(/\ /, "_")}/#{query[:city].downcase.titlecase.gsub(/\ /, "_")}/homes-for-sale?typeBak=realestate&p=#{query[:zip]}&type=classified&priceLow=#{options[:min_price]}&priceHigh=#{options[:max_price]}&bedroomLow=#{options[:bed_room]}&bathroomLow=#{options[:bath_room]}&search=Search"
      else
        yahoo_text = "search/#{query[:state_des].downcase.titlecase.gsub(/\ /, "_")}/#{query[:city].downcase.titlecase.gsub(/\ /, "_")}/homes-for-sale?typeBak=realestate&p=#{query[:city].strip.gsub(/\ /, "+")}%2C+#{query[:state]}&type=classified&priceLow=#{options[:min_price]}&priceHigh=#{options[:max_price]}&bedroomLow=#{options[:bed_room]}&bathroomLow=#{options[:bath_room]}&search=Search"
      end
    else
      yahoo_text = print_yahoo_error(str)
    end
  end
  
  def format_trulia_str_with_option(is_valid, str, options, query)
    if is_valid
      if !query[:zip].blank?
        trulia_text = "for_sale/#{query[:zip]}_zip/#{options[:min_price]}-#{options[:max_price]}_price/#{options[:bed_room]}p_beds/#{options[:bath_room]}p_baths/"
      else
        trulia_text = "for_sale/#{query[:city].gsub(/\ /, "_")},#{query[:state]}/#{options[:min_price]}-#{options[:max_price]}_price/#{options[:bed_room]}p_beds/#{options[:bath_room]}p_baths/"
      end
    else
      trulia_text = print_trulia_error(str)
    end
  end
  
  def format_options(obj)
    options = {:min_price => "0", :max_price => "100000000", :bath_room => "1", :bed_room => "1"}
    options[:bath_room] = obj[:bath_room].gsub(/\+/, "").to_i
    options[:bed_room] = obj[:bed_room].gsub(/\+/, "").to_i
    options[:min_price] = obj[:min_price].gsub(/[\$,]/, "").to_i
    options[:max_price] = obj[:max_price].gsub(/[\$,]/, "").to_i
    options
  end
  
  def search_state(state)
    if ZipCode::STATE_CODE.include?(state.strip.upcase)
      state_index = ZipCode::STATE_CODE.index(state.strip.upcase)
      state = ZipCode::STATE_DES[state_index].strip
      trulia_text = "sitemap/#{state.titlecase.gsub(/\ /, "-")}-real-estate"
    elsif ZipCode::STATE_DES.include?(state.strip.upcase)
      trulia_text = "sitemap/#{state.strip.titlecase.gsub(/\ /, "-")}-real-estate"
    else
      trulia_text = print_trulia_error(state)
    end
  end
  
  def populate_query(str, query)
    zip ||= str.split(/\D/).to_s
    if zip.blank?
      if str.match(/,/)
        strs = str.split(/,/)
        query[:city] = strs[0].strip
        query[:state] = strs[1].strip
        result = search_city_and_state(query[:city], query[:state])
        if !result.blank?
          query[:state_des] = result.state_des
          return true
        else
          return false
        end
      else
        return false
      end
    else
      query[:zip] = zip.strip
      result = search_zip(query[:zip])
      if !result.blank?
        query[:city] = result.city
        query[:state] = result.state
        query[:state_des] = result.state_des
        return true
      else
        return false
      end
    end
  end
  
  def search_zip(zip)
    search = Ultrasphinx::Search.new(:query => "zip:#{zip}", :class_names => "ZipCode")
    search.run
    result = search.results.first
  end
  
  def search_city(city)
    search = Ultrasphinx::Search.new(:query => "city:#{city}",
                                     :class_names => "ZipCode",
                                     :sort_mode => 'ascending',
                                     :sort_by => 'state')
    search.run
    result = search.results.first
  end
  
  def search_city_and_state(city, state)
    search = Ultrasphinx::Search.new(:query => "state:#{state} OR state_des:#{state} AND city:#{city} ",
                                     :class_names => "ZipCode")
    search.run
    result = search.results.first
  end
  
  def format_trulia_str(is_valid, str, query)
    if is_valid
      if !query[:zip].blank?
        trulia_text = "#{query[:state]}/#{query[:city].gsub(/\ /, "_")}/#{query[:zip]}"
      else
        trulia_text = "#{query[:state]}/#{query[:city].gsub(/\ /, "_")}"
      end
    else
      trulia_text = print_trulia_error(str)
    end
  end
  
  def print_trulia_error(str)
    "advanced/error/?error_code=0&error_param=#{str.gsub(/\ /, "+")}"
  end
  
  def print_yahoo_error(str)
    "search/homes-for-sale;_ylt=Ai66yS24iyJKsx25et_uC82kF7kF?typeBak=realestate&p=#{str}&type=classified&priceLow=&priceHigh=&bedroomLow=&bathroomLow=&search=Search"
  end
  
  def print_realtor_error
    "realestateandhomes-search"
  end
  
  def print_century21_error(str)
    "http://www.century21.com/realestatesearch/#{str}?svf=lsp&q=&where=&where=&where=&where=&x=0&y=0&proximity=&minprice=&maxprice=&minbeds=&maxbeds=&minbaths=&maxbaths=&minsqft=&maxsqft="
  end
  
  def print_homes_error
    "Content/SearchOptions.cfm?PropType=&MinPrice=&MaxPrice=&Bedrooms=&Fullbaths=&City=&State="
  end
  
  class String
    def titlecase
       non_capitalized = %w{etc and by the for on is at to but nor or a via}
       gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
    end
  end
end