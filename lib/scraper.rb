require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    student_index_page = Nokogiri::HTML(open(index_url))
    student_array = []
    student_index_page.css("div.student-card").each do |student|
      student_info = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      student_array << student_info
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    student_profile_page = Nokogiri::HTML(open(profile_url))
    student_profile = {}
    link_array = student_profile_page.css(".social-icon-container a").collect {|icon| icon.attribute("href").value}
    link_array.each do |link|
      if link.include?("twitter")
        student_profile[:twitter] = link
      elsif link.include?("linkedin")
        student_profile[:linkedin] = link
      elsif link.include?("github")
        student_profile[:github] = link
      elsif link.include?(".com")
        student_profile[:blog] = link
      end
    end
    student_profile[:profile_quote] = student_profile_page.css("div.profile-quote").text
    student_profile[:bio] = student_profile_page.css("div.description-holder p").text
    student_profile
  end

end

# test_hash = Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/joe-burgess.html")
# binding.pry
# "blah"