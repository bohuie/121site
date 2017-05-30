class Game < ActiveRecord::Base

	belongs_to :user
	has_many :practices
	belongs_to :topic
	
	after_save :set_course

	after_create :do_setID
  
  	private
    	def do_setID
     		newID = self.id
      		self.update_attributes(:game_id => newID)
		end

		def set_course
			self.course_id = self.topic.course_id unless self.topic.nil?
		end
end