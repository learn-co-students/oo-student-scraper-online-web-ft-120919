require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class CommandLineInterface
  BASE_PATH = "https://learn-co-curriculum.github.io/student-scraper-test-page/"

  def run
    make_students
    add_attributes_to_students
    display_students
  end
=begin
  => [{:name=>"Ryan Johnson", :location=>"New York, NY", :profile_url=>"students/ryan-johnson.html"},
      {:name=>"Eric Chu", :location=>"Glenelg, MD", :profile_url=>"students/eric-chu.html"},
      {:name=>"Aaron Enser", :location=>"Scottsdale, AZ", :profile_url=>"students/aaron-enser.html"},
=end

  def make_students
    # https://learn-co-curriculum.github.io/student-scraper-test-page/index.html
    students_array = Scraper.scrape_index_page(BASE_PATH + 'index.html')
    Student.create_from_collection(students_array)
  end

  def add_attributes_to_students
    Student.all.each do |student|
      attributes = Scraper.scrape_profile_page(BASE_PATH + student.profile_url)
      student.add_student_attributes(attributes)
    end
  end

  def display_students
    Student.all.each do |student|
      puts "#{student.name.upcase}".colorize(:blue)
      puts "  location:".colorize(:light_blue) + " #{student.location}"
      puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
      puts "  bio:".colorize(:light_blue) + " #{student.bio}"
      puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
      puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
      puts "  github:".colorize(:light_blue) + " #{student.github}"
      puts "  blog:".colorize(:light_blue) + " #{student.blog}"
      puts "----------------------".colorize(:green)
    end
  end

end
