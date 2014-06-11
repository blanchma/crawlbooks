class Downloader

  def self.run
    downloader = new File.readlines("links.txt")
    downloader.download
  end

  def initialize(array_of_links)
    @array_of_links = array_of_links
  end

  def download
    Dir.mkdir("books") unless File.exists?("books")
    @array_of_links.each do |link|
      match_data = link.match(/.*\/(.*)\n/)
      book = match_data[1]
      File.open("books/#{book}", "wb") do |f|
        puts "Downloading #{book} from  #{link}"
        f.write HTTParty.get(link).parsed_response
        puts "--- #{book} downloaded ---"
      end
    end
  end
end
