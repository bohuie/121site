class User < ActiveRecord::Base
  rolify

  after_create :assign_default_role

  has_many :questions
  #User.with_role(:student, Course.find(1)).course_student_questions(Course.find(1)).count
  scope :course_student_questions, lambda { |course| joins(:questions).where("questions.course_created_in_id = ?", course.id) }
  #User.with_role(:student, Lab.find(1).course).lab_student_questions(Lab.find(1)).count
  scope :lab_student_questions, lambda { |lab| joins(:questions).where("questions.lab_id = ?", lab.id) }

  has_many :teach_courses, class_name: "Course", foreign_key: "instructor_id"

  has_many :student_courses
  has_many :courses, through: :student_courses

  has_many :student_labs
  has_many :labs, through: :student_labs
  has_many :practices
  #User.with_role(:student, Course.find(1)).course_student_practices(Course.find(1)).count
  scope :course_student_practices, lambda { |course| joins(:practices).where("practices.course_id = ?", course.id) }
  #User.with_role(:student, Lab.find(1).course).lab_student_practices(Lab.find(1)).count
  scope :lab_student_practices, lambda { |lab| joins(:practices).where("practices.lab_id = ?", lab.id) }

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

    def assign_default_role
      self.add_role(:student) if self.roles.blank?
    end
end