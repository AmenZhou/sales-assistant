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
    export_to_file(grabs, 'open_table')
  rescue Exception => e
    print 'Error:' + e.inspect
  end


  def self.hundred_best
    url_base = 'http://www.timeout.com/'
    grabs_total = []
    %w(american bbq-soul pizza delicatessen british-irish indian chinese japanese middle-eastern thai creative-asian french italian vegetarian spanish seafood mexican steakhouses fine-dining).each do |genre|
      hrefs = get_links_from_url(url_base + 'newyork/restaurants/100-best-new-york-restaurants-' + genre, '.given-name')
      grabs = fetching_detail_page(url_base, hrefs){ |html| hundred_best_parse(html) }
      grabs_total += grabs
    end
    export_to_file(grabs_total, 'hundred_best')
  rescue Exception => e
    print 'Error:' + e.inspect
  end


  private

  def self.hundred_best_parse(html)
    grab = Grab.new
    if html
      grab.title = html.css('.relative h1').text
      grab.cuisine = html.css('.tags .secondary_tag_name').text.squish
      grab.area = html.css('.location .secondary_tag_name').text.squish
      unless  html.css('.timeoutStarRating  span').empty?
        grab.rating = html.css('.timeoutStarRating  span').attr('title').value
      end
      grab.address = html.css('.address p').text.squish
      grab.phone = html.css('.venueDetails ul')[1].css('li p')[1].text.squish
      grab.website = html.css('.venueDetails ul')[1].css('li p')[2].text.squish
    end
    grab
  rescue Exception => e
    puts 'Error' + e.inspect
  end

  def self.get_links_from_url(url, class_name)
    html = Nokogiri::HTML(open(url))
    hrefs = []
    html.css(class_name).each do |link|
      hrefs << link.attr('href')
    end
    hrefs
  end

  def self.fetching_detail_page(url_base, hrefs)
    puts 'Fetching Detail Pages'
    grabs = []
    hrefs.each do |link|
      html = Nokogiri::HTML(open(url_base + link))
      if block_given? and grab = yield(html)
        grabs << grab 
        print '.'
      end
    end
    grabs
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

  def self.export_to_file(grabs, file_name_prefix)
    puts 'Export to a csv file'
    time = Time.now.strftime('%m-%d-%Y_%H:%M')
    titles = %w(title rating address cuisine phone area website)
    File.open("lib/#{file_name_prefix}_#{time}.csv", 'w') do |f|
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
