# frozen_string_literal: true

require 'test_helper'

class EverypoliticianIndexTest < Minitest::Test
  def test_country
    VCR.use_cassette('countries_json') do
      index = Everypolitician::Index.new
      sweden = index.country('Sweden')
      assert_equal 99_935, sweden.legislature('Riksdag').statement_count
    end
  end

  def test_country_with_index_url
    VCR.use_cassette('countries_json@bc95a4a') do
      index_url = 'https://raw.githubusercontent.com/' \
        'everypolitician/everypolitician-data/bc95a4a/countries.json'
      index = Everypolitician::Index.new(index_url: index_url)
      sweden = index.country('Sweden')
      assert_equal 96_236, sweden.legislature('Riksdag').statement_count
    end
  end

  def test_country_lowercase_slug
    VCR.use_cassette('countries_json') do
      index = Everypolitician::Index.new
      refute_nil index.country('sweden')
    end
  end

  def test_countries
    VCR.use_cassette('countries_json') do
      index = Everypolitician::Index.new
      assert_equal 233, index.countries.size
    end
  end

  def test_all_legislatures
    VCR.use_cassette('countries_json') do
      all = Everypolitician::Index.new.all_legislatures
      assert_equal 243, all.count
      assert_equal 'People\'s Assembly', all.first.name
      assert_equal 'Lagting', all.last.name
    end
  end
end
