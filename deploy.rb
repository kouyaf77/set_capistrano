require 'capistrano/ext/multistage'
require 'bundler/capistrano'

# Application name
set :application, "App_name" #set app name

# Repository
set :repository,  "git@github.com:USER_NAME/REPOSITORY.git" #set repository
set :scm, :git

# RVM
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-2.0.0-p247' #fix for enviroment
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm" #fix for enviroment

# Deploy user
set :user, 'USER_NAME'  #set user in deploy server
set :user_sudo, false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
ssh_options[:port] = PORT_NUMBER #set port number for ssh

# Set tag, branch or revision
set :current_rev, `git show --format='%H' -s`.chomp
set :branch, "master"  #set branch for deploy

set :unicorn_config,  "config/unicorn.rb" #set unicorn setting file

# for Unicorn
#current_path set /depory/producion or etc.
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    #add --path /subdirectory if deploying subdirectory
    run "cd #{current_path} && bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop do
  end

  task :migrate, :roles => :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:migrate"
  end

  task :create_db, :roles => :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:create"
  end

  task :restart, :roles => :web, :except => { :no_release => true } do
    run "kill -USR2 `cat #{pid_file}`"
  end

  task :reload, :roles => :web, :except => { :no_release => true } do
    run "kill -HUP `cat #{pid_file}`"
  end

  task :delete_old do
    set :keep_releases, 2
  end
end
