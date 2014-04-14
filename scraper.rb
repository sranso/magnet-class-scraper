require 'open-uri'
require 'nokogiri'
require 'debugger'

class Scraper
  attr_reader :html, :cmd

  def initialize(url)
    download = open(url)
    @html = Nokogiri::HTML(download)
    @cmd = "curl -X POST https://api.twilio.com/2010-04-01/Accounts/AC3dcdb952070290a6e98490c1e807e6c2/SMS/Messages.json \
      -u AC3dcdb952070290a6e98490c1e807e6c2:453a2167a8835d1d3818fff3f8dd15fc \
      -d 'From=+19199481387' \
      -d 'To=+19196324696' \
      -d 'Body=A Magnet Class is open!'"
  end

  def find_levelfour
    rows = html.search('.class-row.vevent')
    rows.each do |row|
      if title(row) && date(row) && status(row)
        puts `#{cmd}`
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
sc.find_levelfour

