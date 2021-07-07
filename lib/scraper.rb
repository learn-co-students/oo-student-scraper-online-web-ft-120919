require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    array=[]
    roster = Nokogiri::HTML(open(index_url))
    students = roster.css("div.student-card")
    students.each do |student|
      name = student.css("h4.student-name").text
      location = student.css("p.student-location").text
      url = student.css("a").attribute("href").value
      hash= {
          :name => name,
          :location => location,
          :profile_url => url
      }
      array<< hash
    end
      #binding.pry
    array
  end

  def self.scrape_profile_page(profile_url)
    hash = {}
    student = Nokogiri::HTML(open(profile_url))
    # twitter, linkedin, github, blog etc.
    social_links = student.css("div.social-icon-container a")
    social_links.each do |link|
      l = link.attribute("href").value
      ld = l.downcase
      if ld.match?("twitter")
        hash[:twitter] = l
      elsif ld.match?("linkedin")
        hash[:linkedin] = l
      elsif ld.match?("github")
        hash[:github]= l
      else
        hash[:blog] = l
      end
    end
    # profile quote
    pq = student.css("div.vitals-text-container div.profile-quote")
    if pq!=nil
      profile_quote = pq.text
      hash[:profile_quote]= profile_quote
    end
    # bio
    b = student.css("div.bio-content.content-holder div.description-holder p")
    if b!=nil
      bio = b.text
      hash[:bio]= bio
    end
    hash
      #binding.pry
  end

end

#url = "https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"
#Scraper.scrape_index_page(url)

#url = "https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html"
#Scraper.scrape_profile_page(url)