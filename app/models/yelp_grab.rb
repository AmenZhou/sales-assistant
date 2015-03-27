#require_relative '../../lib/yelp'
class YelpGrab < ActiveRecord::Base
  include CsvParse
  include ExportCsv
  include Scraper::YelpScraper

  self.per_page = 10
end
