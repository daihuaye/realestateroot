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
class ZipCodeSearchGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = "ZipCodeSearchExample"

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

   def manifest
      record do |m|

         # Always create the model with the search functions
         m.directory File.join('app/models', class_path)
         m.template 'model.rb', 
                File.join('app/models', 
                           class_path, 
                          "#{file_name}.rb")

         # Unless they pass --skip-migration, also create a new example
         # migration for the user to hack on.
         unless options[:skip_migration]
            m.migration_template 'migration.rb', 
                                 'db/migrate', 
                                  :assigns => { :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}" }, 
                                  :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
         end

         # Unless they pass --skip-example, also create a new example
         # controller and views for the user to play with.
         unless options[:skip_example]
            m.directory File.join('app/controllers', controller_class_path)
            m.directory File.join('app/views', controller_class_path, controller_file_name)
            m.template 'controller.rb', 
                File.join('app/controllers', 
                           controller_class_path, 
                          "#{controller_file_name}_controller.rb")


                 m.template "index.rhtml",
                            File.join('app/views', 
                                       controller_class_path, 
                                       controller_file_name, "index.rhtml")

         end

      end
   end 
  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} zip_code_search [--skip-migration] [--skip-example] [ModelName] "
    end

    # Override to add your options to the parser:                                                                          
    #   def add_options!(opt)
    #     opt.on('-v', '--verbose') { |value| options[:verbose] = value }                                                  
    #   end
    def add_options!(opt)                                                                                                  
      opt.on('-m', '--skip-migration') { |value| options[:skip_migration] = true }                                                  
      opt.on('-e', '--skip-example') { |value| options[:skip_example] = true }                                                  
    end       


end

