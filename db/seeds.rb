# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Test for ultrasphinx
# @search = Ultrasphinx::Search.new(:query => "zip:95129", :class_names => "ZipCode")
# @search.run
# @results = @search.results
# p @results

# populate coloum -state_des- for database zip_codes
zips = ZipCode.find(:all)
counter = 0
zips.each do |z|
  case z.state
  when ZipCode::STATE_CODE[0]
    z.update_attribute(:state_des, ZipCode::STATE_DES[0].strip)
  when ZipCode::STATE_CODE[1]
    z.update_attribute(:state_des, ZipCode::STATE_DES[1].strip)
  when ZipCode::STATE_CODE[2]
    z.update_attribute(:state_des, ZipCode::STATE_DES[2].strip)
  when ZipCode::STATE_CODE[3]
    z.update_attribute(:state_des, ZipCode::STATE_DES[3].strip)
  when ZipCode::STATE_CODE[4]
    z.update_attribute(:state_des, ZipCode::STATE_DES[4].strip)
  when ZipCode::STATE_CODE[5]
    z.update_attribute(:state_des, ZipCode::STATE_DES[5].strip)
  when ZipCode::STATE_CODE[6]
    z.update_attribute(:state_des, ZipCode::STATE_DES[6].strip)
  when ZipCode::STATE_CODE[7]
    z.update_attribute(:state_des, ZipCode::STATE_DES[7].strip)
  when ZipCode::STATE_CODE[8]
    z.update_attribute(:state_des, ZipCode::STATE_DES[8].strip)
  when ZipCode::STATE_CODE[9]
    z.update_attribute(:state_des, ZipCode::STATE_DES[9].strip)
  when ZipCode::STATE_CODE[10]
    z.update_attribute(:state_des, ZipCode::STATE_DES[10].strip)
  when ZipCode::STATE_CODE[11]
    z.update_attribute(:state_des, ZipCode::STATE_DES[11].strip)
  when ZipCode::STATE_CODE[12]
    z.update_attribute(:state_des, ZipCode::STATE_DES[12].strip)
  when ZipCode::STATE_CODE[13]
    z.update_attribute(:state_des, ZipCode::STATE_DES[13].strip)
  when ZipCode::STATE_CODE[14]
    z.update_attribute(:state_des, ZipCode::STATE_DES[14].strip)
  when ZipCode::STATE_CODE[15]
    z.update_attribute(:state_des, ZipCode::STATE_DES[15].strip)
  when ZipCode::STATE_CODE[16]
    z.update_attribute(:state_des, ZipCode::STATE_DES[16].strip)
  when ZipCode::STATE_CODE[17]
    z.update_attribute(:state_des, ZipCode::STATE_DES[17].strip)
  when ZipCode::STATE_CODE[18]
    z.update_attribute(:state_des, ZipCode::STATE_DES[18].strip)
  when ZipCode::STATE_CODE[19]
    z.update_attribute(:state_des, ZipCode::STATE_DES[19].strip)
  when ZipCode::STATE_CODE[20]
    z.update_attribute(:state_des, ZipCode::STATE_DES[20].strip)
  when ZipCode::STATE_CODE[21]
    z.update_attribute(:state_des, ZipCode::STATE_DES[21].strip)
  when ZipCode::STATE_CODE[22]
    z.update_attribute(:state_des, ZipCode::STATE_DES[22].strip)
  when ZipCode::STATE_CODE[23]
    z.update_attribute(:state_des, ZipCode::STATE_DES[23].strip)
  when ZipCode::STATE_CODE[24]
    z.update_attribute(:state_des, ZipCode::STATE_DES[24].strip)
  when ZipCode::STATE_CODE[25]
    z.update_attribute(:state_des, ZipCode::STATE_DES[25].strip)
  when ZipCode::STATE_CODE[26]
    z.update_attribute(:state_des, ZipCode::STATE_DES[26].strip)
  when ZipCode::STATE_CODE[27]
    z.update_attribute(:state_des, ZipCode::STATE_DES[27].strip)
  when ZipCode::STATE_CODE[28]
    z.update_attribute(:state_des, ZipCode::STATE_DES[28].strip)
  when ZipCode::STATE_CODE[29]
    z.update_attribute(:state_des, ZipCode::STATE_DES[29].strip)
  when ZipCode::STATE_CODE[30]
    z.update_attribute(:state_des, ZipCode::STATE_DES[30].strip)
  when ZipCode::STATE_CODE[31]
    z.update_attribute(:state_des, ZipCode::STATE_DES[31].strip)
  when ZipCode::STATE_CODE[32]
    z.update_attribute(:state_des, ZipCode::STATE_DES[32].strip)
  when ZipCode::STATE_CODE[33]
    z.update_attribute(:state_des, ZipCode::STATE_DES[33].strip)
  when ZipCode::STATE_CODE[34]
    z.update_attribute(:state_des, ZipCode::STATE_DES[34].strip)
  when ZipCode::STATE_CODE[35]
    z.update_attribute(:state_des, ZipCode::STATE_DES[35].strip)
  when ZipCode::STATE_CODE[36]
    z.update_attribute(:state_des, ZipCode::STATE_DES[36].strip)
  when ZipCode::STATE_CODE[37]
    z.update_attribute(:state_des, ZipCode::STATE_DES[37].strip)
  when ZipCode::STATE_CODE[38]
    z.update_attribute(:state_des, ZipCode::STATE_DES[38].strip)
  when ZipCode::STATE_CODE[39]
    z.update_attribute(:state_des, ZipCode::STATE_DES[39].strip)
  when ZipCode::STATE_CODE[40]
    z.update_attribute(:state_des, ZipCode::STATE_DES[40].strip)
  when ZipCode::STATE_CODE[41]
    z.update_attribute(:state_des, ZipCode::STATE_DES[41].strip)
  when ZipCode::STATE_CODE[42]
    z.update_attribute(:state_des, ZipCode::STATE_DES[42].strip)
  when ZipCode::STATE_CODE[43]
    z.update_attribute(:state_des, ZipCode::STATE_DES[43].strip)
  when ZipCode::STATE_CODE[44]
    z.update_attribute(:state_des, ZipCode::STATE_DES[44].strip)
  when ZipCode::STATE_CODE[45]
    z.update_attribute(:state_des, ZipCode::STATE_DES[45].strip)
  when ZipCode::STATE_CODE[46]
    z.update_attribute(:state_des, ZipCode::STATE_DES[46].strip)
  when ZipCode::STATE_CODE[47]
    z.update_attribute(:state_des, ZipCode::STATE_DES[47].strip)
  when ZipCode::STATE_CODE[48]
    z.update_attribute(:state_des, ZipCode::STATE_DES[48].strip)
  when ZipCode::STATE_CODE[49]
    z.update_attribute(:state_des, ZipCode::STATE_DES[49].strip)
  else
    p "Not Found: ERROR"
  end
  counter += 1;
end

p "END Result: #{counter} times loop"


# create cities of USA array
# zips = ZipCode.find(:all, :order => "city ASC")
# 
# p "#{zips[0][:city]}, #{zips[0][:state]}" #print the first one
# counter = 0
# is_same = 0
# is_diff_city = 0
# 
# class String
#   def titlecase
#      non_capitalized = %w{etc and by the for on is at to but nor or a via}
#      gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
#   end
# end
# 
# def printCitiesAndState( city, state )
#   print "\""
#   print "#{city.downcase.titlecase}, #{state}"
#   print "\""
#   print ","
#   print "\n"
# end
# 
# for i in 1..42740 do
#   cur = zips[i][:city]
#   cur_state = zips[i][:state]
#   j =  i - 1
#   while j > 0 && is_same == 0 && is_diff_city == 0 do
#     walker = zips[j][:city]
#     walker_state = zips[j][:state]
#     
#     if walker.eql?(cur) && walker_state.eql?(cur_state)
#       is_same = 1;
#     end
#     
#     if !walker.eql?(cur)
#       is_diff_city = 1
#     end
#     
#     j -= 1
#   end
#   
#   if is_same == 0
#     printCitiesAndState( cur, cur_state )
#     counter += 1
#   end
#   
#   is_diff_city = 0
#   is_same = 0
# end
# 
# p "END Result: #{counter} times loop"
# 

# agent = WWW::Mechanize.new
# page = agent.get("http://www.homes.com/")
# search_form = page.form_with(:name => "SearchForm")
# search_form.field_with(:name => "location").value = "san josa"
# # search_form.field_with(:name => "MinPrice").value = "900000"
# # search_form.field_with(:name => "MaxPrice").value = "10000000"
# # search_form.field_with(:name => "Bedrooms").value = "3+"
# # search_form.field_with(:name => "FullBaths").value = "3+"
# search_results = agent.submit(search_form)
# puts search_results.uri

