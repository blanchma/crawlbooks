require_relative 'test_helper'
require 'crawlbooks'


class TestCrawlbooks < MiniTest::Unit::TestCase

  def test_result_class
    assert_instance_of Array, Crawlbooks.new.run
  end

  def test_result
    refute_empty Crawlbooks.new.run
  end

  def test_contain_a_dropbox_link
    assert Crawlbooks.new.run.include?('http://dl.dropbox.com/u/66288738/V/Vernant-Jean-El-Universo-Los-Dioses-Los-Hombres.pdf')
  end

  def test_crawl_page
    assert_instance_of Crawlbooks.new.page, String
  end

end