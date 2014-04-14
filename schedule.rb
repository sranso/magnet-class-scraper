require 'whenever'

every 6.hours do
  `ruby scraper.rb`
end