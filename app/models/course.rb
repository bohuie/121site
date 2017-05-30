class Course < ActiveRecord::Base
	#Instructor
	belongs_to :instructor, class_name: :User

	#Students taking the course
	has_many :student_courses
	has_many :students, through: :student_courses

	#Topics belonging to the course
	has_many :topics

	#Questions belonging to the course
	has_many :questions

	has_many :labs
end
