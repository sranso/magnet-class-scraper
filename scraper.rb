require 'open-uri'
require 'nokogiri'
require 'debugger'

class Scraper
  attr_reader :html

  def initialize(url)
    download = open(url)
    @html = Nokogiri::HTML(download)
  end

  def find_levelfour
    rows = html.search('.class-row.vevent')
    rows.each do |row|
      if title(row) && date(row) && status(row)
        debugger
        puts 'hi'
      end
    end
  end

  def title(row)
    return true if row.search('h5').text.include? "Level Four"
  end

  def date(row)
    return true if row.search('dd')[0].text != "TBD"
  end

  def status(row)
    the_status = row.search('.link').text
    if (the_status != "Wait List") && (the_status != "InSession")
      return true 
    end
  end
end

sc = Scraper.new('http://www.magnettheater.com/classlist.php')
html = sc.html
sc.find_levelfour
debugger
puts 'hi'