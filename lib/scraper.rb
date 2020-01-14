require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = page.css(".student-card")
    student_data = []
    students.each_with_index do |student, i|
      student_data[i] = {}
      student_data[i][:name] = student.css("h4").text
      student_data[i][:location] = student.css("p").text
      web_name = student_data[i][:name].downcase.split.join("-")
      student_data[i][:profile_url] = "students/#{web_name}.html"
    end
    student_data
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    info = page.css("div.social-icon-container").children
    websites = []
    indeces = [1, 3, 5]
    indeces.each_with_index do |num, i|
      if info[num] != nil
        websites[i] = []
        websites[i] << info[num].attribute("href").value
        websites[i] << info[num].attribute("href").value.delete_prefix("https://").delete_prefix("www.").split(".")
      end
    end
    profile = {}
    website_names = ["twitter", "linkedin", "github"]
    website_names.each_with_index do |name, i|
      websites.each do |site|
        if site[1][0] == name
          profile[name.to_sym] = site[0]
        end
      end
    end
    if info[7] != nil
      profile[:blog] = info[7].attribute("href").value
    end
    profile[:profile_quote] = page.css("div.profile-quote").text
    profile[:bio] = page.css("div.description-holder p").text
    profile
  end

end
