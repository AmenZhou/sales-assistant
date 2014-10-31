class Grab
require 'open-uri'
  attr_accessor :title, :rating, :cuisine, :phone, :website, :address, :area
  def self.open_table
    url = 'http://www.opentable.com/promo.aspx?m=8&ref=14383&pid=69&gclid=COnP3-r7xcECFYlDaQodQTQAdg'
    html = Nokogiri::HTML(open(url))
    hrefs = []
    html.css('.r').each do |link|
      hrefs << link.attr('href')
    end
    grabs = []
    url_base = 'http://www.opentable.com/'
    puts 'Fetching Detail Pages'
    hrefs.each do |link|
      html = Nokogiri::HTML(open(url_base + link))
      if grab = open_table_parse(html)
        grabs << grab 
        print '.'
      end
    end
    puts 'Export to a csv file'
    export_to_file(grabs)
  rescue Exception => e
    print 'Error:' + e.inspect
  end

  def self.open_table_parse(html)
    grab = Grab.new
    if html and info = html.css('.information') and !info.empty?
      grab.title = info.css('.title').try(:text)
      unless info.css('span[itemprop="ratingValue"]').empty?
        grab.rating = info.try(:css, 'span[itemprop="ratingValue"]').try(:attr, 'title').try(:value)
      end
      grab.address = info.css('span[itemprop="streetAddress"]').try(:text)
      grab.area = info.css('span[class="text"]')[1].try(:text)
      grab.cuisine = info.css('span[class="text"]')[2].try(:text)
      grab.phone = info.css('li[id="Phone"] span[class="value"]').try(:text)
      grab.website = info.css('li[id="Website"] a').try(:text)
    end
    grab
  rescue Exception => e
    puts 'Error' + e.inspect
  end

  def self.export_to_file(grabs)
    time = Time.now.strftime('%m-%d-%Y_%H:%I')
    titles = %w(title rating address cuisine phone area website)
    File.open("lib/open_table_#{time}.csv", 'w') do |f|
      titles.each do |t|
        f.write(t + '|')
      end
      f.write("\n")
      grabs.each do |grab|
        titles.each do |t|
          if value = grab.send(t)
            f.write(value + '|')
          end
        end
        f.write("\n")
        print '.'
      end
    end
  end
end
