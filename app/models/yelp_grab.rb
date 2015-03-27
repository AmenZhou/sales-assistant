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

  def self.grab_all
    yelp_urls = [
           {url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Alphabet_City,Battery_Park,Chelsea]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Chinatown,Civic_Center,East_Harlem]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:East_Village",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Flatiron,Gramercy]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Harlem,Inwood,Kips_Bay]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:Hell%27s_Kitchen",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Koreatown,Little_Italy,Lower_East_Side,Manhattan_Valley]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Marble_Hill,Meatpacking_District,Morningside_Heights,Murray_Hill,NoHo,Nolita,Roosevelt_Island,SoHo,South_Street_Seaport]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[South_Village,Stuyvesant_Town,TriBeCa,Two_Bridges,Union_Square]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
           {
            url: "http://www.yelp.com/search?find_desc=&find_loc=ny&ns=1&cflt=restaurants&l=p:NY:New_York:Manhattan:[Financial_District,Greenwich_Village]",
            borough: "Manhattan",
            primary_industry: "restaurant"
           },
   ]


    yelp_urls.each do |yelp_url|
      browser_grab(yelp_url[:url], borough: yelp_url[:borough], primary_industry: yelp_url[:primary_industry])
    end
  end
end
