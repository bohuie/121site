class Lab < ActiveRecord::Base

	has_many :questions, through: :course
	has_many :practices

	belongs_to :course

	#Students taking the labs
	has_many :student_labs
	has_many :students, through: :student_labs
end
