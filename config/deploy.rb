# config valid only for current version of Capistrano
lock "3.8.1"

set :application, '121site'
set :repo_url, 'https://github.com/bohuie/121site'
set :deploy_to, '/srv/www/vhosts/ubc.ca/ok/quiznova/html/public'
set :branch, "master"

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/application.yml')

set :rails_env, "production"
set :stages, "production"
set :deploy_via, :copy
set :keep_releases, 5

set :assets_roles, [:web, :app] 

server "edgemap.ok.ubc.ca", :roles => [:app, :web, :db], :primary => true, user: 'edgemap'