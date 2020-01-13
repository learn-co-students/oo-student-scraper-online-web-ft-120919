class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student)

    student.each do |k,v|
      self.send("#{k}=",v)
    end
=begin
        @name = student[:name]
        @location = student[:location]
        @profile_url = student[:profile_url]
=end
    @@all<< self
  end


  def self.create_from_collection(students_array)
    students_array.each do |student|
      Student.new(student)
    end
  end

  def add_student_attributes(a)
    a.each do |k,v|
      self.send("#{k}=",v)
    end
=begin
    @twitter = a[:twitter]
    @linkedin= a[:linkedin]
    @github=a[:github]
    @blog = a[:blog]
    @profile_quote=a[:profile_quote]
    @bio = a[:bio]
=end
    self
  end

  def self.all
    @@all
  end
end

