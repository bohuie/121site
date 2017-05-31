class User < ActiveRecord::Base
  rolify

  has_many :questions
  has_many :teach_courses, class_name: "Course", foreign_key: "instructor_id"
  has_many :student_courses
  has_many :courses, through: :student_courses
  has_many :student_labs
  has_many :labs, through: :student_labs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 
  validates :username, uniqueness: true

  validates :username, :fname, :lname, :studentnumber,  presence:  true
  validates_inclusion_of  :instructor, :in => [true, false]
  validates_inclusion_of  :assistant, :in => [true, false]
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: true }

  after_create :do_setID

  def fullname
    return self.fname + " " + self.lname
  end
  
  private

    def do_setID
      
      newID = self.id
      self.update_attributes(:user_id => newID)


    end

    def self.find_for_database_authentication(conditions={})
      self.where("username = ?", conditions[:email]).limit(1).first ||
      self.where("email = ?", conditions[:email]).limit(1).first
    end
end