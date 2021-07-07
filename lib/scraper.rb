require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css(".student-card").each do |student|
    name = student.css(".student-name").text
    location = student.css(".student-location").text
    profile_url = student.css("a").attribute("href").value
    student_info = {
      :name => name,
      :location => location,
      :profile_url => profile_url
    }
    students << student_info
      end
    students
  end

  def self.scrape_profile_page(profile_url)
    url = open(profile_url)
    page = Nokogiri::HTML(url)
    student_hash = {}
    page.css("div.social-icon-container a").each do |link|
      case link.attribute("href").value
      when /twitter/
        student_hash[:twitter] = link.attribute("href").value
      when /github/
        student_hash[:github] = link.attribute("href").value
      when /linkedin/
        student_hash[:linkedin] = link.attribute("href").value
      else
        student_hash[:blog] = link.attribute("href").value
      end
    end
    student_hash[:profile_quote] = page.css("div.profile-quote").text
    student_hash[:bio] = page.css("div.bio-content div.description-holder").text.strip
    student_hash
  end

end

