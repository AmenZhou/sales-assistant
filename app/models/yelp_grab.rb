#require_relative '../../lib/yelp'
class YelpGrab < ActiveRecord::Base
  include CsvParse
  include ExportCsv
  include Scraper::YelpScraper

  self.per_page = 10

  def self.cvs_import path
    csv_parse(path).each do |params|
      yp = find_or_initialize_by(address: params["address"])
      yp.update!(params)
    end
  end
end
