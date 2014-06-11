require "rubygems"
require "bundler"
require 'rake/testtask'
require_relative 'lib/crawlbooks'
require_relative 'lib/downloader'

desc "Crawl all links"
task :crawl do
  Crawlbooks.new.run
end

desc "Download all links"
task :download do
  Downloader.run
end

Rake::TestTask.new do |t|
  #t.libs.push "lib"
  t.libs = ["lib"]
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :default => [:crawl]
