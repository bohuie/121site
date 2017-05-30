class Practice < ActiveRecord::Base

	belongs_to :user
	belongs_to :topic
	belongs_to :question

	after_create :set_course

	after_create :do_setID
  
  	private
    	def do_setID
     		newID = self.id
      		self.update_attributes(:practice_id => newID)
		end

		def set_course
			self.course_id = self.topic.course_id unless self.topic.nil?
		end
end