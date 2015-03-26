#require_relative '../../lib/yelp'
class YelpGrab < ActiveRecord::Base

  self.per_page = 10
  def YelpGrab::grab area = "NYC", keywords = "restaurants"
    begin_time = Time.now
    (1..50).each do |i|
      rs = Yelp.client.search(area, { term: keywords,
                                      limit: 20, 
                                     offset: (i * 20)})
      rs.businesses.each do |business|
        yp = YelpGrab.find_or_create_by(yelp_id: business.id)
        yp.name = business.try('name')
        yp.phone_num = business.try('display_phone')
        yp.url = business.try('url')
        yp.city = business.try('location').try('neighborhoods').try(:join, ", ")
        yp.zipcode = business.try('location').try('postal_code')
        yp.address = business.try('location').try('address').try(:first)
        yp.state = business.try(:location).try(:state_code)
        yp.country = business.try(:location).try(:country_code)
        yp.address_remark = cross_streets(business)
        yp.rating = business.try('rating')
        yp.genre = business.categories.map(&:first).join(", ") if business.categories
        yp.save!
      end
    end
    end_time = Time.now
    puts "Time cost: #{(end_time - begin_time).floor}"
  end

  def YelpGrab::export
    File.open('public/yelp.csv', 'w') do |file|
      file.puts "name | phone num | rating | genre | url | city | zipcode | state | address | address remark"
      YelpGrab.order(updated_at: :desc).each do |yp|
        file.puts "#{yp.name} | #{yp.phone_num} | #{yp.rating} | #{yp.genre} | #{yp.url} | #{yp.city} | #{yp.zipcode} | #{yp.state} | #{yp.address} | #{yp.address_remark}"
      end
    end
  end

  require 'open-uri'
  require 'watir-webdriver'

  def self.browser_grab url
    
    (1..5).each do |page|
	    request_url = url + '#' + "start=#{page * 10}"
	    client = Selenium::WebDriver::Remote::Http::Default.new
	    client.timeout = 60
	    browser = Watir::Browser.new :firefox, :http_client => client
	    browser.goto request_url

	    browser.ul(class: "search-results").wait_until_present
	    doc = get_doc_by_browser(browser)
            parse_doc(doc)
	    p "Finish One page"
	    browser.close
	    client.close
    end
  end

  def self.get_doc_by_browser(browser)
    Nokogiri::HTML.parse(browser.html)
  end

  def self.parse_doc(doc)
    doc.css("ul.search-results").css(".search-result").each do |item|
      biz_address = item.css("address").text.strip
      yp = YelpGrab.find_or_initialize_by(name: biz_address)
      biz_name = item.css("a.biz-name").text.strip
      yp_url = item.css("a.biz-name").attribute("href").value
      yp.rating = item.css(".rating-large").css("i").attribute("title").value.strip
      yp.genre = item.css(".category-str-list").css("a").text.strip
      yp.city = item.css(".neighborhood-str-list").text.strip
      yp.zipcode = biz_address.match(/\d{5}\Z/).to_s
      yp.phone_num = item.css(".biz-phone").text.strip
      yp.save!
      print "."
    end 
  end

  private

  def self.cross_streets business
    business.try(:location).try(:cross_streets)
  end
end
