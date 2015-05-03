class YelpdataSearch
  attr_accessor :name, :genre, :borough, :city, :zipcode, :address
  include ActiveModel::Model

  def initialize search_params = {}
    search_params.each do |key, value|
      self.send("#{key}=", value.present? ? value : nil)
    end
  end

  def results
    search_res = YelpGrab.all
    search_res = search_res.where('lower(name) LIKE ?', "%#{name.downcase}%") if name
    search_res = search_res.where(genre: genre) if genre
    search_res = search_res.where('address LIKE ?', "%#{address}%") if address
    search_res = search_res.where(borough: borough) if borough
    search_res = search_res.where(zipcode: zipcode) if zipcode
    search_res = search_res.where(city: city) if city
    search_res
  end
end
