require 'open-uri' # To open the passed URL
require 'nokogiri' # To process the HTML file

class WebScraper

  def scrape(argv)
    doc = Nokogiri::HTML(open(argv))

    scraped_data = []

    scraped_data << self.scrape_title(doc)
    scraped_data << self.scrape_points(doc)
    scraped_data << self.scrape_id(doc)
    scraped_data << self.scrape_url
    scraped_data << self.scrape_comments(doc)

    raise FailedScrape if scraped_data.empty?

    scraped_data

  end

  def scrape_title(doc)
    # Find and store the title element's HTML
    raw_title = doc.search('title:nth-of-type(1)')[0].inner_text
    # Split the title into an array
    title = raw_title.split
    # Remove the last three items (not part of the title)
    3.times {title.pop}
    # Restore the title into a string
    title = title.join(' ')
  end

  def scrape_id(doc)
    # Find and store an href attribute containing the ID
    raw_id = doc.search('center > a:first-child')[0]['href']
    # Regex the id and convert to integer, then return
    @id = /\d+$/.match(raw_id)[0].to_i
  end

  def scrape_url
    # Combine the ID with the standard URL prefix, then return
    "https://news.ycombinator.com/item?id="+@id.to_s
  end

  def scrape_points(doc)
    # Find the points using attribute selectors
    raw_points = doc.search('td[class="subtext"] > span[class="score"]')[0].inner_text
    # Regex just the points and convert to integer, then return
    points = (/^\d+/.match(raw_points))[0].to_i
  end

  def scrape_comments(doc)
    # Find comments
    raw_comments = doc.search('span[class="comment"] > span:first-child')

    # Push into an array of comments
    comments = raw_comments.map do |comment|
      comment = comment.inner_text.split
      comment.delete_at(-1)
      comment.join(' ')
    end
    # Return comments (array of strings)
    comments
  end  

end
