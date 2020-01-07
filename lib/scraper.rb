require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(open(index_url))

    students = []

    index.css("div.student-card").each do |student|
      instance = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
  
      students << instance
    end

    students

  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))

    student = {}

    links = profile.css("div.social-icon-container").children.css("a").map { |i| i.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter") 
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile.css(".profile-quote").text
    student[:bio] = profile.css("div.description-holder p").text
    student
  end
  
 
end
