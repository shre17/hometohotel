# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'homes2hotels'

# set :repo_url, 'git@bitbucket.org:sushma-patil/hometohotels.git'
set :repo_url, 'git@bitbucket.org:ee_linarez/homes-2-hotels.git'
set :branch, "master"

set :user, "ubuntu"
set :rails_env, 'production'
set :deploy_to, "/www/homes2hotels"
set :deploy_via, :remote_cache
set :use_sudo, false

set :ssh_options, {
  keys: %w(/home/sumit/.ssh/homes2hotels_key.pem),
  forward_agent: true,
  user: 'ubuntu'
}

namespace :nginx do
  desc "restart nginx"
    task :restart, :clear_cache do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
        within release_path do
          execute "sudo kill $(cat /opt/nginx/logs/nginx.pid)"
          execute "sudo /opt/nginx/sbin/nginx"
        end
      end
    end
end

namespace :deploy do
  desc 'Runs rake db:create'
  task :create => [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end
end