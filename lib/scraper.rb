require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = []
    doc.css("div.student-card").each do|item|
      students << {:name => item.css("h4.student-name").text,
      :location => item.css("p.student-location").text,
      :profile_url => item.css('a').attribute("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    result = {}
    links = doc.css(".social-icon-container a")
    links.each do |link|
      if link.attribute("href").value.include? "twitter"
        result[:twitter] = link.attribute("href").value
      elsif link.attribute("href").value.include? "kedin"
        result[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include? "thub"
        result[:github] = link.attribute("href").value
      else
        result[:blog] = link.attribute("href").value
      end
    end
    result[:profile_quote]=   doc.css("div.profile-quote").text if  doc.css("div.profile-quote")
    result[:bio]=  doc.css(".description-holder p").text if doc.css(".description-holder p")
    result
  end

end
