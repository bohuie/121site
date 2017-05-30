class Question < ActiveRecord::Base

	belongs_to :user
	belongs_to :topic
	belongs_to :course
	has_many :practices

	validates :qtext, :a1text, :a2text, :a3text, :a4text, :answer, :topic, presence: true

	after_create :do_setID
  
  	private
    	def do_setID
     		newID = self.id
      		self.update_attributes(:question_id => newID)
		end
end