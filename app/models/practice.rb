class Practice < ActiveRecord::Base

	belongs_to :user
	belongs_to :question
	belongs_to :course
	belongs_to :lab
	accepts_nested_attributes_for :question
end