require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML.parse(open(index_url))
    students = doc.css(".student-card")
    result = []
    students.each{ |s|
      f = {}
      f[:name] = s.children[1].css(".student-name").text
      f[:location] = s.children[1].css("p")[0].children.text
      f[:profile_url] = s.css("a")[0]["href"]
      result.push(f)
    }
    #binding.pry
    result
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML.parse(open(profile_url))
    socials = doc.css(".social-icon-container a")
    links = {}

    socials.each{ |link|
      url = link[:href]
      if url.include? "twitter"
        links[:twitter] = url
      elsif url.include? "github"
        links[:github] = url
      elsif url.include? "linkedin"
        links[:linkedin] = url
      else
        links[:blog] = url
      end
    }
    #binding.pry
    links[:profile_quote] = doc.css(".profile-quote").text.strip
    links[:bio] = doc.css(".description-holder p").text
    links
  end

end
