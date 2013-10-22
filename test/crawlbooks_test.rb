require_relative 'test_helper'
require 'crawlbooks'


class TestCrawlbooks < MiniTest::Unit::TestCase

  def test_scan_categories
    assert Crawlbooks::CATEGORY_REGEX =~ "<a href=\"http://bibliophiliaparana.wordpress.com/category/astrada/\">Astrada</a>"
  end

  def test_scan_dropbox_with_slash
    assert Crawlbooks::DROPBOX_REGEX =~ "<a href=\"http://dl.dropbox.com/u/66288738/V/Vernant-Jean-El-Universo-Los-Dioses-Los-Hombres.pdf/\">Ble</a>"
  end

  def test_scan_dropbox_without_slash
    assert Crawlbooks::DROPBOX_REGEX =~ "<a href=\"http://dl.dropbox.com/u/66288738/V/Vernant-Jean-El-Universo-Los-Dioses-Los-Hombres.pdf\">Ble</a>"
  end

  def test_scan_posts_without_hash
    assert Crawlbooks::POST_REGEX =~ "<a href=\"http://bibliophiliaparana.wordpress.com/2012/05/06/adorno-theodor-w-educacion-para-la-emancipacion-2/\">"
  end

  def test_scan_posts_with_hash
    link = Crawlbooks::POST_REGEX.match("<a href=\"http://bibliophiliaparana.wordpress.com/2012/05/06/adorno-theodor-w-educacion-para-la-emancipacion-2/#respond\">")[0]
    assert link == "http://bibliophiliaparana.wordpress.com/2012/05/06/adorno-theodor-w-educacion-para-la-emancipacion-2"
  end

  def test_hard_scan_dropbox
    html_fragment = "http://dl.dropbox.com/u/66288738/O/Onfray-Michel-Teoria-Del-Cuerpo-Enamorado-Por-Una-Erotica-OCR-NoSCrbd.pdf\">http://dl.dropbox.com/u/66288738/O/Onfray-Michel-Teoria-Del-Cuerpo-Enamorado-Por-Una-Erotica-OCR-NoSCrbd.pdf"
    refute Crawlbooks::DROPBOX_REGEX.match(html_fragment)[0]  == html_fragment
  end

  def test_contain_many_dropbox_link
    crawl = Crawlbooks.new.run
    assert crawl.include?('http://dl.dropbox.com/u/66288738/V/Vernant-Jean-El-Universo-Los-Dioses-Los-Hombres.pdf')
    assert crawl.size > 20
  end

end