require_relative 'test_helper'
require 'crawlbooks'


class TestCrawlbooks < MiniTest::Unit::TestCase

  def test_open_uri
    assert_instance_of  Array, Crawlbooks.new.run
  end



end