class Topic < ActiveRecord::Base

	has_many :questions
	has_many :practices, through: :questions
	has_many :games
	
	has_many :course_topics
	has_many :courses, through: :course_topics
	
	attr_accessor :course_id

	validates :name, presence: true
end