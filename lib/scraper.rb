require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    Scraper.scrape_index_page(index_url)
  end

  def self.scrape_profile_page(profile_url)
    Scraper.scrape_profile_page(profile_url)
  end
  
  class Scrapper
  attr_accessor :scrape_index_page, :scrape_profile_page
  @@all = []
  def initialize
    @@all << self
  end
  def self.all
    @@all
  end
  def self.reset_all
    @@all.clear
  end
end

  class Butterfly::Scraper 
  attr_accessor :name 
  
  def self.scrape_chairs
    doc = Nokogiri::HTML(open("https://www.roomandboard.com/catalog/living/sofas-and-loveseats"))
    
    chairs = doc.css("div.pg-name")
    
    chairs.each do |c|
      name = c.text  
      Butterfly::Chair.new(name)
    end
    
    def self.scrape_details
   doc = Nokogiri::HTML(open("https://www.roomandboard.com/catalog/living/sofas-and-loveseats"))
   
   details = doc.css("div.pg-details div.pg-name div.pg-price-range div.pg-options")
   
   details.each do |d|
     info = d.text
     Butterfly::Details.new(info)
  end
end 

  
end

