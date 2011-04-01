class WellcomeController < ApplicationController
  def index
    @search_trulia_text = ""
    @search_zillow_text = ""
  end
  
  def paypal_url
    values = params[:donate]
    redirect_to "https://www.paypal.com/cgi-bin/webscr?" + values.map {|k, v| "#{k}=#{v}" }.join("&")
  end
  
  def valify
    render :layout => false
  end
  
  def visualTabs
    render :layout => false
  end
end