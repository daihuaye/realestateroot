# Copyright (c) 2006  Doug Fales 
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
# 2006) and is released under the M

class <%= class_name %> < ActiveRecord::Base
   # See: http://www.codeproject.com/dotnet/Zip_code_radius_search.asp
   # Equatorial radius of the earth from WGS 84 
   # in meters, semi major axis = a
   A = 6378137;
   # flattening = 1/298.257223563 = 0.0033528106647474805
   # first eccentricity squared = e = (2-flattening)*flattening
   E = 0.0066943799901413165;
   # Miles to Meters conversion factor (take inverse for opposite)
   MILES_TO_METERS = 1609.347;
   # Degrees to Radians converstion factor (take inverse for opposite)
   DEGREES_TO_RADIANS = Math::PI/180;

   attr_accessor :search_zip, :distance_to_search_zip

   def find_objects_within_radius(radius_in_miles, &finder_block)
      self.search_zip = self
      self.distance_to_search_zip = 0
      radius = radius_in_miles*MILES_TO_METERS
      lat0 = self.latitude * DEGREES_TO_RADIANS
      lon0 = self.longitude * DEGREES_TO_RADIANS
      rm = calc_meridional_radius_of_curvature(lat0)
      rpv = calc_ro_cin_prime_vertical(lat0)

      #Find boundaries for curvilinear plane that encloses search ellipse
      max_lat = (radius/rm+lat0)/DEGREES_TO_RADIANS;
      max_lon = (radius/(rpv*Math::cos(lat0))+lon0)/DEGREES_TO_RADIANS;
      min_lat = (lat0-radius/rm)/DEGREES_TO_RADIANS;
      min_lon = (lon0-radius/(rpv*Math::cos(lat0)))/DEGREES_TO_RADIANS;

      # Get all zips within min/mix here
      #zip_codes = self.find(:all, :conditions => ["latitude > ? AND longitude > ? AND latitude < ? AND longitude < ? ", min_lat, min_lon, max_lat, max_lon])
      zip_codes = yield(min_lat, min_lon, max_lat, max_lon)

      # Now calc distances from centroid, and remove results that were returned 
      # in the curvilinear plane, but are outside of the ellipsoid geodetic
      result = []
      zip_codes.each do |zip|
         z_lat = zip.lat * DEGREES_TO_RADIANS
         z_lon = zip.lon * DEGREES_TO_RADIANS
         distance_to_centroid = calc_distance_lat_lon(rm, rpv, lat0, lon0, z_lat, z_lon)
         if distance_to_centroid <= radius
           zip.distance_to_search_zip = distance_to_centroid
           result << zip
         end
      end
      return result.sort { |a, b| a.distance_to_search_zip <=> b.distance_to_search_zip }
   end

   def distance_to_search_zip(units = 'kilometers')
     if units =~ /mile/i
       return @distance_to_search_zip/MILES_TO_METERS
     elsif units =~/kilometer/
       return @distance_to_search_zip/1000.0
     else
       return @distance_to_search_zip
     end
   end

   def calc_distance_lat_lon(rm, rpv, lat0, lon0, lat, lon)
      Math::sqrt(  (rm ** 2) * ((lat-lat0)**2) + (rpv ** 2) * (Math::cos(lat0)**2) * ((lon-lon0) ** 2) )
   end


   def calc_meridional_radius_of_curvature(lat0)
      A*(1-E)/((1 - E * ((Math::sin(lat0) ** 2))) ** 1.5)
   end

   def calc_ro_cin_prime_vertical(lat0)
      A / Math::sqrt( 1 - E * (Math::sin(lat0) ** 2))
   end

   def lat() read_attribute(:latitude).to_f; end
   def lon() read_attribute(:longitude).to_f; end
   def latitude() read_attribute(:latitude).to_f; end
   def longitude() read_attribute(:longitude).to_f; end
end
