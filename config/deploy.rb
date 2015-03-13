# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'sales-assistant'
set :repo_url, 'git@github.com:AmenZhou/sales-assistant.git'

# Default branch is :master
 ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, '/home/action/workspace/www/sales-assistant'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
 set :linked_files, fetch(:linked_files, []).push('config/database.yml' , 'config/local_env.yml')

# Default value for linked_dirs is []
 set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :chruby_ruby, 'ruby-2.2.0'
set :chruby_exec, '/home/action/.parts/bin/chruby-exec'
set :rails_env, 'production'
set :puma_config_path, -> { File.join(current_path, "config", "puma.rb") }
set :puma_pid,  -> { File.join(shared_path, "tmp", "pids", "puma.group.pid") }

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      if test "[ -f #{fetch(:puma_pid)} ]"
        execute "kill -USR2 `cat #{fetch(:puma_pid)}`"
      else
        within current_path do
          execute :bundle, "exec puma", "--config", fetch(:puma_config_path), "-e", fetch(:rails_env), "-d"
          invoke 'delayed_job:restart'
        end
      end
    end
  end
end
