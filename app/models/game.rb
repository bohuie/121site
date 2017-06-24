class Game < ActiveRecord::Base

	belongs_to :user
	has_many :practices
	belongs_to :course
	belongs_to :topic

	validates :course, presence: true
end