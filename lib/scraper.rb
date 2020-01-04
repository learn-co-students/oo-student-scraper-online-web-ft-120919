require 'open-uri'
require 'pry'

class Scraper 

  
#is a class method that scrapes the student index page ('./fixtures/student-site/index.html') and a returns an array of hashes in which each hash represents one student
  def self.scrape_index_page(index_url)
    studentscraper = Nokogiri::HTML(open(index_url))
    students = []
    studentscraper.css("div.student-card").each do |student|
      student_info = {}
      student_info[:name] = student.css("h4.student-name").text
      student_info[:location] = student.css("p.student-location").text
      student_info[:profile_url] = student.css("a").attribute("href").value
      students << student_info

    end
    students
  end

  #is a class method that scrapes a student's profile page and returns a hash of attributes describing an individual student
  #can handle profile pages without all of the social links
  def self.scrape_profile_page(profile_url)
   
     profilepage = Nokogiri::HTML(open(profile_url))
     student_profile = {}
     links = profilepage.css("div.social-icon-container a")
     links.each do |link|
            if link.attribute("href").value.include?("twitter")
              student_profile[:twitter] = link.attribute("href").value
            elsif link.attribute("href").value.include?("linkedin")
              student_profile[:linkedin] = link.attribute("href").value
            elsif link.attribute("href").value.include?("github")
              student_profile[:github] = link.attribute("href").value
            elsif link.attribute("href").value.include?(".com")
              student_profile[:blog] = link.attribute("href").value
            end
     end
     student_profile[:profile_quote] = profilepage.css("div.profile-quote").text
     student_profile[:bio] = profilepage.css("div.description-holder p").text 

     student_profile
  end
  
end

=begin
{
  :twitter=>"http://twitter.com/flatironschool",
  :linkedin=>"https://www.linkedin.com/in/flatironschool",
  :github=>"https://github.com/learn-co",
  :blog=>"http://flatironschool.com",
  :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
  :bio=> "I'm a school"
}
=end

#students: doc.css("div.student-card")
#name: student.css(" h4.student-name").text
#location : student.css("p.student-location").text
#profile-url:student.css("a").attribute("href").value

#socialmedia :profilepage.css("div.social-icon-container a")
#profile-quote: profilepage.css("div.profile-quote").text
#bio : profilepage.css("div.description-holder p").text