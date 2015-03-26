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
        yp.city = business.try('location').try('neighborhoods')
        yp.zipcode = business.try('location').try('postal_code')
        yp.address = business.try('location').try('address')
        yp.state = business.try(:location).try(:state_code)
        yp.country = business.try(:location).try(:country_code)
        yp.address_remark = cross_streets(business)
        yp.rating = business.try('rating')
        yp.genre = business.categories.map(&:first).join(", ") if business.categories
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

  private

  def self.cross_streets business
    business.try(:location).try(:cross_streets)
  end
end
