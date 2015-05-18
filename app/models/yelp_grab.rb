#require_relative '../../lib/yelp'
class YelpGrab < ActiveRecord::Base
  include CsvParse
  include ExportCsv
  include Scraper::YelpScraper

  self.per_page = 20

  scope :text_search, ->(attr, value){ where("lower(#{attr}) like ?", "%#{value.downcase}%") }

  def self.csv_import path
    csv_parse(path).each do |params|
      yp = find_or_initialize_by(address: params["address"])
      yp.update!(params)
    end
  end

  def self.genres
    pluck(:genre).compact.uniq.reject!(&:blank?)
  end

  def self.boroughs
    pluck(:borough).compact.uniq
  end

  def self.zipcodes
    pluck(:zipcode).compact.uniq.reject!(&:blank?).sort
  end

  def self.cities
    pluck(:city).compact.uniq.reject!(&:blank?)
  end

  def self.grab_all
    yelp_urls = [
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:Theater_District",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:Upper_East_Side",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Upper_West_Side,Washington_Heights]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Brooklyn:Bay_Ridge",
            borough: "Brooklyn",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:West_Village",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Brooklyn:[Bath_Beach,Bergen_Beach,Boerum_Hill]",
            borough: "Brooklyn",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:Yorkville",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Brooklyn:[Bedford_Stuyvesant,Bensonhurst]",
            borough: "Brooklyn",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Brooklyn:[Borough_Park,Brighton_Beach,Brooklyn_Heights,Brownsville,Canarsie,Carroll_Gardens,City_Line]",
            borough: "Brooklyn",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Brooklyn:[Bushwick,Clinton_Hill,Cobble_Hill,Columbia_Street_Waterfront_District,Coney_Island]",
            borough: "Brooklyn",
            primary_industry: "restaurant"
           },
    ]


    yelp_urls.each do |yelp_url|
      browser_grab(yelp_url[:url], borough: yelp_url[:borough], primary_industry: yelp_url[:primary_industry])
    end
  end
end
