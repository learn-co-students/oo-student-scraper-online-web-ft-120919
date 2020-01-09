require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc_students = Nokogiri::HTML(open(index_url)).css("div.student-card")
    students = []
    doc_students.each do |student|
      hash = {
      name: student.css("h4.student-name").text,
      location: student.css("p.student-location").text,
      profile_url: student.css("a").attribute("href").value
      }
      students << hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url)).css("div.main-wrapper")
    hash = {}
    hash[:profile_quote] = doc.css("div.vitals-text-container div.profile-quote").text
    hash[:bio] = doc.css("div.bio-content p").text
    doc.css("div.social-icon-container a").each do |social|
      link = social.attribute("href").value
      key = link.split("/")[2].chomp(".com")
      key = key.split(".")[1] if key.include?("www.")
      if key == "twitter"
        hash[:twitter] = link
      elsif key == "linkedin"
        hash[:linkedin] = link
      elsif key == "github"
        hash[:github] = link
      else
        hash[:blog] = link
      end
    end
    hash
  end
end
