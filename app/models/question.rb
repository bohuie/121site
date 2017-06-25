class Question < ActiveRecord::Base

	attr_accessor :course_id

	belongs_to :user
	belongs_to :topic
	belongs_to :lab

	has_many :practices
	
	has_many :courses, through: :topic
	belongs_to :course_created_in, class_name: :Course

	validates :qtext, :a1text, :a2text, :a3text, :a4text, :answer, :topic, presence: true
end