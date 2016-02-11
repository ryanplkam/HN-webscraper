require 'colorize' # To colorize outputs
require './post.rb' # To create the new post
require './comment.rb' # To create the comment objects
require './web_scraper.rb' # To scrape the url

class UI

  def output
    puts "Post title: " + "#{@post.title}".colorize(:green)
    puts "Post points: " + "#{@post.points}".colorize(:light_green)
    puts "Post ID: " + "#{@post.item_id}".colorize(:light_red)
    puts "Post url: " + "#{@post.url}".colorize(:green)
    puts "Number of comments: " + "#{@post.comments.length}".colorize(:blue)
  end

  def create_post(scraped_data)    
    
    begin
      # Convert scraped data from scraper into instance variables
      title = scraped_data[0]
      points = scraped_data[1]
      id = scraped_data[2]
      url = scraped_data[3]
      comments = scraped_data[4]

      # Create a new post without any comments
      @post = Post.new(title, url, points, id)

      # Add comments to each post
      comments.each do |comment|
        @post.add_comment(Comment.new(comment))
      end
    rescue InvalidPostOrComment
      puts "Invalid arguments passed to the Post or Comment intialize!"
    rescue FailedScrape
      puts "Scrape failed!"
    end

  end

end


web_scraper = WebScraper.new
ui = UI.new

ui.create_post(web_scraper.scrape(ARGV[0]))
ui.output
