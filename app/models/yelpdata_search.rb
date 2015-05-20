class YelpdataSearch
  attr_accessor :name, :genre, :borough, :city, :zipcode, :address, :user_id
  include ActiveModel::Model

  def initialize search_params = {}
    search_params.each do |key, value|
      self.send("#{key}=", value.present? ? value : nil)
    end
  end

  def results
    search_res = YelpGrab.all
    search_res = search_res.where('lower(name) LIKE ?', "%#{name.downcase}%") if name
    search_res = search_res.text_search('genre', genre) if genre
    search_res = search_res.text_search('address', address) if address
    search_res = search_res.where(borough: borough) if borough
    search_res = search_res.where(zipcode: zipcode) if zipcode
    search_res = search_res.text_search("city", city) if city
    search_res = search_res.where(user_id: user_id) if user_id
    search_res
  end
end
