require "bundler"
Bundler.require

class Crawlbooks
  CATEGORY_REGEX=/(http:\/\/bibliophiliaparana.wordpress.com\/category\/\S*)"/
  POST_REGEX=/(http:\/\/bibliophiliaparana.wordpress.com\/\d+\/\d+\/\d+\/\S*)"/
  DROPBOX_REGEX=/http:\/\/dl.dropbox.com\/\S*\.pdf\/?"/
  #http://bibliophiliaparana.wordpress.com/

  def run
    @links, @posts = [], []
    ['http://dl.dropbox.com/u/66288738/V/Vernant-Jean-El-Universo-Los-Dioses-Los-Hombres.pdf']
    response = HTTParty.get "http://bibliophiliaparana.wordpress.com/"
    home = response.body

    category_sections = scan_categories(home)
    category_sections.uniq!

    puts "#{category_sections.size} category links collected"
    i = 0
    category_sections.each do |category_link|
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
      end
      break if @links.size == 5
    end
    @links.uniq!

    puts "#{@links.size} dropbox links collected"
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