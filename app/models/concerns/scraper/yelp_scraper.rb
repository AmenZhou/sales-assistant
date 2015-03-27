module Scraper

  module YelpScraper
  require 'open-uri'
  require 'watir-webdriver'
  extend ActiveSupport::Concern

    module ClassMethods
      def browser_grab url
        (1..99).each do |page|
          request_url = url + '&' + "start=#{page * 10}"
          client = Selenium::WebDriver::Remote::Http::Default.new
          client.timeout = 60
          browser = Watir::Browser.new :firefox, :http_client => client
          browser.goto request_url

          browser.ul(class: "search-results").wait_until_present
          doc = get_doc_by_browser(browser)
          parse_doc(doc, borough: nil, primary_industry: "Food", country: "US", state: "NY")
          p "Finish One page"
          record_log("Finish one page: " + request_url)
          browser.close
          client.close
        end
      end

      def get_doc_by_browser(browser)
        Nokogiri::HTML.parse(browser.html)
      end

      def parse_doc(doc, options = {})
        doc.css("ul.search-results").css(".search-result").each do |item|
          biz_address = item.css("address").text.strip
          yp = find_or_initialize_by(address: biz_address)
          yp.name = item.css("a.biz-name").text.strip
          yp.url = item.css("a.biz-name").attribute("href").value
          yp.rating = item.css(".rating-large").css("i").attribute("title").value.strip if item.css(".rating-large").css("i").present?
          yp.genre = item.css(".category-str-list").css("a").text.strip
          yp.city = item.css(".neighborhood-str-list").text.strip
          yp.zipcode = biz_address.match(/\d{5}\Z/).to_s
          yp.phone_num = item.css(".biz-phone").text.strip
          options.each do |k, v|
            yp.send("#{k}=", v)
          end
          yp.save!
        end 
      end

      def record_log(logs)
        my_logger ||= Logger.new("#{Rails.root}/log/grab.log")
        my_logger.info("Record log at #{Time.zone.now}: " + logs)
      end

      def grab area = "NYC", keywords = "restaurants"
        begin_time = Time.now
        (1..50).each do |i|
          rs = Yelp.client.search(area, { term: keywords,
                                          limit: 20, 
                                          offset: (i * 20)})
          rs.businesses.each do |business|
            yp = find_or_initialize_by(yelp_id: business.id)
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

      private

      def cross_streets business
        business.try(:location).try(:cross_streets)
      end
    end
  end
end
