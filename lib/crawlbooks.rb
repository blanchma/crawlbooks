require "bundler"
require "thread"
require "benchmark"

Bundler.require

class Crawlbooks
  CATEGORY_REGEX=/(http:\/\/bibliophiliaparana.wordpress.com\/category\/\S*)"/
  POST_REGEX=/(http:\/\/bibliophiliaparana.wordpress.com\/\d+\/\d+\/\d+\/[^#\/]*)/#/(http:\/\/bibliophiliaparana.wordpress.com\/\d+\/\d+\/\d+\/\S*\/?)#?"/
  DROPBOX_REGEX=/http:\/\/dl.dropbox.com\/\S*\.pdf\/?"/
  #http://bibliophiliaparana.wordpress.com/

  def run
    Benchmark.measure do
      @links, @posts, @crawlers = [], [], []
      response = HTTParty.get "http://bibliophiliaparana.wordpress.com/"
      home = response.body

      category_sections = scan_categories(home)
      category_sections.uniq!

      puts "#{category_sections.size} category links collected"
      category_sections.each do |category_link|
        crawl_category(category_link)
      end

      @links.uniq!
      puts "#{@links.size} dropbox links collected"
    end
    File.new("links.txt","w").write @links.join("\n")
    @links
  end

  def crawl_category(category_link)
    puts "Scanning category: #{category_link}"
    category = HTTParty.get category_link
    posts = scan_posts(category.body)
    posts.uniq! #clean non unique links
    posts  -= @posts #just new ones
    @posts += posts #store all the post links

    posts.each do |post_link|
      puts "Scanning posts: #{post_link}"
      post = HTTParty.get post_link
      links = scan_dropbox_links(post.body)
      links.each{|l| puts l}
      @links += links
      puts "Links crawled in #{category_link}:"
      puts links.join("\n")
    end
  end

  #/"(http:\/\/\S*)"/
  def scan_categories(body)
    body.scan(CATEGORY_REGEX).flatten
  end

  def scan_posts(body)
    body.scan(POST_REGEX).flatten
  end

  def scan_dropbox_links(body)
    body.scan(DROPBOX_REGEX).flatten
  end


end
