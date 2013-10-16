set :rails_env, 'production'
set :deploy_env, 'production'
# Directories
#set deploying directory
#ex. "/usr_local/rails_apps/app"
set :deploy_to, "app_path"
set :current_path, "#{deploy_to}/current" #for Capistrano
#set pid setting unicorn
#ex. /tmp_unicorn_app.pid"
set :pid_file, "/app.pid"

server "IP adress", :app, :web, :db, primary: true #set IP adress
