#require_relative '../../lib/yelp'
class YelpGrab < ActiveRecord::Base

  before_save :set_cross_street

  self.per_page = 10
  def YelpGrab::grab
    begin_time = Time.now
    (1..30).each do |i|
    begin
      rs = Yelp.client.search('NYC', { term: 'best restaurants for restaurant week',
                                      limit: 20, 
                                     offset: (i * 20)})
    rescue Exception => e
      logger.fatal e
      break
    end
    rs.businesses.each do |business|
      yp = YelpGrab.find_or_create_by(yelp_id: business.id)
      yp.update_attributes(
        name: business.try('name'),
        phone_num: business.try('display_phone'),
        url: business.try('url'),
        city: business.try('location').try('neighborhoods'),
        zipcode: business.try('location').try('postal_code'),
        address: business.try('location').try('address'),
        state: business.try(:location).try(:state_code),
        country: business.try(:location).try(:country_code),
        address_remark: business.try(:location).try(:cross_streets),
        rating: business.try('rating'),
        genre: business.try('categories').try(:join, ' ')
      )
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

  def set_cross_street
    self.cross_street = cross_street.join(", ") if cross_street
    true
  end
end
