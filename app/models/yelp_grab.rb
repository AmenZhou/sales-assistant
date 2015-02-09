#require_relative '../../lib/yelp'
class YelpGrab < ActiveRecord::Base
  self.per_page = 10
  def YelpGrab::grab
    begin_time = Time.now
    (21..50).each do |i|
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
        city: business.try('location').try('city'),
        zipcode: business.try('location').try('postal_code'),
        street: business.try('location').try('address').try(:join, ''),
        address: business.try('location').try('display_address').try('join', ' '),
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
      file.puts "name | phone num | rating | genre | url | city | zipcode | street | address"
      YelpGrab.all.each do |yp|
        file.puts "#{yp.name} | #{yp.phone_num} | #{yp.rating} | #{yp.genre} | #{yp.url} | #{yp.city} | #{yp.zipcode} | #{yp.street.try(:gsub, /[\[\]"]/, '')} | #{yp.address}"
      end
    end
  end

end
