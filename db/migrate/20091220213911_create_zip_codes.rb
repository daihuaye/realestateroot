class CreateZipCodes < ActiveRecord::Migration
  def self.up

     # WARNING:  This is an example migration for importing zip code data that
     # is already in SQL format.  You will need to customize this according to
     # the format of your data (i.e. CSV, SQL, etc) and the type of databse
     # you're using (i.e.  MySQL, Postgres, Oracle, etc).
     user = ActiveRecord::Base.configurations[RAILS_ENV]['username']
     pass = ActiveRecord::Base.configurations[RAILS_ENV]['password']
     db = ActiveRecord::Base.configurations[RAILS_ENV]['database']

     # An example for MySQL, where your data is neatly contained in an SQL file.  
     # =========================================================================
     # Assuming you have your zip code table schema and data in a file called "db/zip_codes.sql"
     #zip_code_file = File.join(RAILS_ROOT, "db", "zip_codes.sql")

     # Construct a command line to put the data into your current database
     #command_hidden_pw = "mysql -u #{user} --password=#{'*' * pass.length } #{db} < #{zip_code_file} "
     #command =  " mysql -u #{user} --password=#{pass} #{db} < #{zip_code_file} "
     #puts "Attempting to add zip codes table using command: \n\t#{command_hidden_pw}"
     #exec command
     # =========================================================================




     # Leave this uncommented to use the default free data which comes with
     # this plugin, but is also available via: http://www.cfdynamics.com/zipbase/
     # If you don't want to use this data, then comment the following section out.
     # =========================================================================
     create_table "zip_codes", :force => true do |t|
         t.column :zip,            :string
         t.column :city,           :string
         t.column :state,          :string, :limit => 2
         t.column :latitude,       :string
         t.column :longitude,      :string
         t.column :zip_class,      :string
     end


     require 'csv'
     zip_code_data = File.expand_path(File.join(RAILS_ROOT, 'vendor/plugins/zipcodesearch/generators/zip_code_search/templates/zip_code_data.csv'))
     puts "Now importing about 45,000 zip codes from the free data set at http://www.cfdynamics.com/zipbase/."
     puts "This will probably take 5-10 minutes... "
     puts "[NOTE: if you want it to go faster, import the file\n #{zip_code_data} using your database's CSV import mechanism.]"
     CSV.open(zip_code_data, "r") do |row| 
        ZipCode.create!(:zip       => row[0], 
                                 :latitude   => row[1], 
                                 :longitude  => row[2], 
                                 :city       => row[3], 
                                 :state      => row[4], 
                                 :zip_class  => row[5])
     end 
     # =========================================================================

     # No matter how you choose to do it, at the end of this migration, you
     # should have a table called "zip_codes" with at least these fields:
     #     id               :integer(11)   not null, primary key
     #     zip              :string(255)   
     #     city             :string(255)   [optional]
     #     state            :string(255)   [optional]
     #     latitude         :string(255)   
     #     longitude        :string(255)   

  end

  def self.down
     drop_table 'zip_codes'
  end
end
