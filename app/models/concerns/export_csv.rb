module ExportCsv
  extend ActiveSupport::Concern

  module ClassMethods
    def export
      File.open('public/yelp.csv', 'w') do |file|
        file.puts "name | phone num | rating | primary industry | genre | url | city | zipcode | state | address | borough | country | address remark"
        order(updated_at: :desc).each do |yp|
          file.puts "#{yp.name} | #{yp.phone_num} | #{yp.rating} | #{yp.primary_industry} | #{yp.genre} | #{yp.url} | #{yp.city} | #{yp.zipcode} | #{yp.state} | #{yp.address} | #{yp.borough} | #{yp.country} | #{yp.address_remark}"
        end
      end
    end
  end
end

