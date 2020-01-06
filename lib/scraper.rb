require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    #Want a hash for each student containing :name, :location, and :profile_url
    doc = Nokogiri::HTML(open(index_url))

    #roster is an array containing ALL info for ALL students
    roster = doc.css(".roster-cards-container .student-card")

    #pulls off the name of the index-0 student in roster
    #roster[0].css(".card-text-container .student-name").text

    #pulls off the location of the index-0 student in roster
    #roster[0].css(".card-text-container .student-location").text

    #pulls off the profile-url or the index-0 student in roster
    #Looks at the 0th 'a' element and picks off its 'href' attribute
    #roster[0].css('a')[0]['href']

    roster.each_with_index do |student, index|
      students.push << {:name => roster[index].css(".card-text-container .student-name").text, 
                        :location => roster[index].css(".card-text-container .student-location").text,
                        :profile_url => roster[index].css('a')[0]['href']
                       }
    end #each
    students 
  end

  def self.scrape_profile_page(profile_url)
    #If applicable, should contain :twitter, :linkedin, :github
    #:blog, :profile_quote, :bio
    student_hash = {}

    doc = Nokogiri::HTML(open(profile_url))
    
    all_links = doc.css(".social-icon-container a")
    
    all_links.each_with_index do |link, index|
      if all_links[index]['href'].include?("twitter")
        student_hash[:twitter] = all_links[index]['href']
      elsif all_links[index]['href'].include?("linkedin")
        student_hash[:linkedin] = all_links[index]['href']
      elsif all_links[index]['href'].include?("github")
        student_hash[:github] = all_links[index]['href']
      else
        student_hash[:blog] = all_links[index]['href']
      end #if
    end #each
    
    student_hash[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text
    student_hash[:bio] = doc.css(".details-container .description-holder")[0].text.strip
    student_hash 
  end #method
end #class

#s = Scraper.new
#Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/joe-burgess.html")

