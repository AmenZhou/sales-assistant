desc "Backup Database"                                                                                                                                                                 
task backup_database: :environment do
  system "pg_dump -U action -c -N postgis -N topology sales_assistant_production > /home/action/workspace/sales_assistant_db/mysql_dump_#{Time.now.strftime('%d%m%Y-%H:%M')}.sql"
end
