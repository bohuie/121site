class Lab < ActiveRecord::Base
	belongs_to :course

	#Students taking the labs
	has_many :student_labs
	has_many :students, through: :student_labs
end
