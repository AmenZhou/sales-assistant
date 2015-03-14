user = "action"
application = "sales-assistant"
path = "/home/#{user}/workspace/www/sales-assistant/shared"
 
port 5000
threads 0, 4
workers 1

pidfile "#{path}/tmp/pids/puma.#{application}.pid"
stdout_redirect "#{path}/log/puma.stdout", "#{path}/log/puma.stderr", true

preload_app!
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end 
end

