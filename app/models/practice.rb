class Practice < ActiveRecord::Base

	belongs_to :user
	belongs_to :question
	belongs_to :course
	belongs_to :lab
	accepts_nested_attributes_for :question

	#after_create :set_course

	after_create :do_setID
	before_save :set_lab_id
  
  	private
   	def do_setID
     	newID = self.id
      	self.update_attributes(:practice_id => newID)
	end

	def set_course
		#self.course_id = self.topic.course_id unless self.topic.nil?
	end
	def set_lab_id
		unless self.course_id.nil? || self.course.labs.nil?
			self.lab_id = Course.find(self.course_id).labs.includes(:student_labs).where("student_labs.user_id = ?", self.user_id).references(:student_labs).first.id
		end
	end
end