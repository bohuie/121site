class Question < ActiveRecord::Base

	attr_accessor :course_id

	belongs_to :user
	belongs_to :topic
	belongs_to :lab

	has_many :practices
	
	has_many :courses, through: :topic

	validates :qtext, :a1text, :a2text, :a3text, :a4text, :answer, :topic, presence: true

	after_create :do_setID
  
  	private
    	def do_setID
     		newID = self.id
      		self.update_attributes(:question_id => newID)
		end
end