require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    array = []
    doc.css("div.student-card").each do |student|
      hash = {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.css("a").attr("href").text
    }
      array << hash
    end
    array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    
    links = doc.css("div.social-icon-container a").map do |link|
      link.attribute("href").value
    end
    
    hash = {}
    links.each do |link|
      if link.include?("twitter")
        hash[:twitter] = link
      elsif link.include?("linkedin")
        hash[:linkedin] = link
      elsif link.include?("github")
        hash[:github] = link
      else
        hash[:blog] = link
      end
      if doc.css("div.profile-quote").text
        hash[:profile_quote] = doc.css("div.profile-quote").text
      end
      if doc.css("div.description-holder p").text
        hash[:bio] = doc.css("div.description-holder p").text
      end
    end
    hash
  end
end