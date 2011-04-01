set :application, "realestateroot"
set :repository,  "git@173.203.127.72:realestateroot.git"
set :deploy_to, "/var/www/#{application}"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# default_run_options[:pty] = true
# set :use_sudo, true

set :user, "root"
set  :domain, "173.203.127.72"
role :app, domain
role :web, domain
role :db, domain, :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :passenger do
  desc "Restart Application"
  
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  # task :bootstrap do
  #   run "cp #{deploy_to}/config/database.yml #{release_path}/config/"
  #   run "cp #{deploy_to}/releases/production.conf #{release_path}/config/ultrasphinx/"
  #   run "cd #{release_path}"
  #   sudo "apache2ctl restart"
  # end
  
  task :ultrasphinx do
    # run "rm #{deploy_to}/config/ultrasphinx/development.conf"
    run "cd #{deploy_to} && sudo RAILS_ENV=production rake ultrasphinx:bootstrap"
    run "apache2ctl restart"
  end
  
  task :update do
    run "cp #{deploy_to}/current/config/example_database.yml #{deploy_to}/current/config/database.yml"
    run "apache2ctl restart"
  end 
  
end

# after :deploy, "passenger:restart"
# after "deploy:update"
