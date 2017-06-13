class Topic < ActiveRecord::Base

	has_many :questions
	has_many :practices, through: :questions
	has_many :games
	
	has_many :course_topics
	has_many :courses, through: :course_topics
	

	validates :name, presence: true

	after_create :do_setID
  
  	private
    	def do_setID
     		newID = self.id
      		self.update_attributes(:topic_id => newID)
		end
end