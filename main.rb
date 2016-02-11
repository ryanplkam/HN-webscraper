require './ui.rb'

web_scraper = WebScraper.new
ui = UI.new

ui.create_post(web_scraper.scrape(ARGV[0]))
ui.output