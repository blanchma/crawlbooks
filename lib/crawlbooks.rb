#require "bundler"
require "thread"
require "httparty"
require "benchmark"

#Bundler.require

class Crawlbooks
  CATEGORY_REGEX=/(http:\/\/bibliophiliaparana.wordpress.com\/category\/\S*)"/
  POST_REGEX=/(http:\/\/bibliophiliaparana.wordpress.com\/\d+\/\d+\/\d+\/[^#\/]*)/#/(http:\/\/bibliophiliaparana.wordpress.com\/\d+\/\d+\/\d+\/\S*\/?)#?"/
  DROPBOX_REGEX=/(http:\/\/dl.dropbox.com\/\S*\.pdf)\/?"/
  #http://bibliophiliaparana.wordpress.com/

  def run
    @links, posts, crawlers = [], [], []
    Benchmark.measure do
      @mutex = Mutex.new
      response = HTTParty.get "http://bibliophiliaparana.wordpress.com/"
      home = response.body

      category_sections = scan_categories(home)
      category_sections.uniq!

      puts "#{category_sections.size} category links collected"
      category_sections.first(3).each do |category_link|
        crawlers << Thread.new { crawl_category(category_link) }
      end

      crawlers.map(&:join)
    end
    puts "#{@links.size} dropbox links collected"
    File.new("links.txt","w").write @links.join("\n")
    @links
  end

  def crawl_category(category_link)
    puts "Scanning category: #{category_link}"
    category = HTTParty.get category_link
    posts = scan_posts(category.body)
    posts.uniq! #clean non unique links
    posts

    links = []
    posts.each do |post_link|
      puts "Scanning posts: #{post_link}"
      post = HTTParty.get post_link
      _links = scan_dropbox_links(post.body)
      _links.each{|l| puts l}
      puts "#{_links.size} links crawled in #{category_link}"
      links += _links
    end

    @mutex.synchronize {
      @links += links
    }
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
