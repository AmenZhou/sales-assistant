namespace :import do
  desc "import csv file"
  task :csv => :environment do
    Dir.glob('/home/amen/apps/sales-assistant/lib/tasks/*.csv') do |file|
      YelpGrab.csv_import(file)
    end
  end
end
