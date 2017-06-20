class Course < ActiveRecord::Base
	resourcify
	#Instructor
	belongs_to :instructor, class_name: :User

  	has_many :questions_created_in, class_name: "Question", foreign_key: "course_created_in_id"

	#Students taking the course
	has_many :student_courses
	has_many :students, through: :student_courses

	#Topics belonging to the course
	has_many :course_topics
	has_many :topics, through: :course_topics

	#Questions belonging to the course
	has_many :questions, through: :topics

	has_many :labs
	has_many :practices

	has_many :games

	validates :title, presence: { message: 'cannot be empty' }
	validates :subject, presence: { message: 'cannot be empty' }
	validates :year, presence: { message: 'cannot be empty' }
end
