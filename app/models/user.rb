class User < ActiveRecord::Base
  rolify

  after_create :assign_default_role

  has_many :questions

  has_many :teach_courses, class_name: "Course", foreign_key: "instructor_id"

  has_many :student_courses
  has_many :courses, through: :student_courses

  has_many :student_labs
  has_many :labs, through: :student_labs
  has_many :practices

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
  def fullname
    return self.fname + " " + self.lname
  end
  
  private

  def self.find_for_database_authentication(conditions={})
    self.where("username = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end

  def assign_default_role
    if self.roles.blank?
      if self.courses.empty?
        self.add_role(:student)
      else
        self.add_role(:student, self.courses.first)
      end
    end
  end


  ## User and Course/Lab Question Scopes
    ## Currently returns the user info, would like to have it return the questions
  #User.with_role(:student, Course.find(1)).course_student_questions(Course.find(1)).count
  scope :course_student_questions, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.course_created_in_id = ?", course.id) 
    else
      joins(:questions).where("questions.course_created_in_id = ? AND questions.topic_id = ?", course.id, topic.id)
    end
  }
  #User.with_role(:student, Lab.find(1).course).lab_student_questions(Lab.find(1)).count
  scope :lab_student_questions, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.lab_id = ?", lab.id) 
    else
      joins(:questions).where("questions.lab_id = ? AND questions.topic_id = ?", lab.id, topic.id) 
    end
  }
  #Submitted
  scope :course_student_questions_submitted, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE", course.id) 
    else
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.topic_id = ?", course.id, topic.id) 
    end
  }
  scope :lab_student_questions_submitted, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE", lab.id) 
    else
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.topic_id = ?", lab.id, topic.id) 
    end
  }
  #Incorrect
  scope :course_student_questions_incorrect, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade = \'Incorrect\'", course.id) 
    else
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade = \'Incorrect\' AND questions.topic_id = ?", course.id, topic.id) 
    end
  }
  scope :lab_student_questions_incorrect, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade = \'Incorrect\'", lab.id) 
    else
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade = \'Incorrect\' AND questions.topic_id = ?", lab.id, topic.id) 
    end
  }
  #Accepted
  scope :course_student_questions_accept, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade = \'Correct\'", course.id) 
    else
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade = \'Correct\' AND questions.topic_id = ?", course.id, topic.id) 
    end
  }
  scope :lab_student_questions_accept, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade = \'Correct\'", lab.id) 
    else
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade = \'Correct\' AND questions.topic_id = ?", lab.id, topic.id)
    end
  }
  #Revise
  scope :course_student_questions_revise, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade LIKE ?", course.id, "Marker comment%") 
    else
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade LIKE ? AND questions.topic_id = ?", course.id, "Marker comment%", topic.id) 
    end
  }
  scope :lab_student_questions_revise, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade LIKE ?", lab.id, "Marker comment%") 
    else
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade LIKE ? AND questions.topic_id = ?", lab.id, "Marker comment%", topic.id) 
    end
  }
  #Pending
  scope :course_student_questions_pending, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade = \'Review Pending\'", course.id) 
    else
      joins(:questions).where("questions.course_created_in_id = ? AND questions.submitted = TRUE AND questions.grade = \'Review Pending\' AND questions.topic_id = ?", course.id, topic.id) 
    end
  }
  scope :lab_student_questions_pending, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade = \'Review Pending\'", lab.id) 
    else
      joins(:questions).where("questions.lab_id = ? AND questions.submitted = TRUE AND questions.grade = \'Review Pending\' AND questions.topic_id = ?", lab.id, topic.id) 
    end
  }

  ## User and Couse/Lab Practice Scopes
    ## Currently returns the user info, would like to have it return the practices

  #User.with_role(:student, Course.find(1)).course_student_practices(Course.find(1)).count
  scope :course_student_practices, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:practices).where("practices.course_id = ?", course.id) 
    else
      joins(:practices => :question).where("practices.course_id = ? AND questions.topic_id = ?", course.id, topic.id)
    end
  }
  #User.with_role(:student, Lab.find(1).course).lab_student_practices(Lab.find(1)).count
  scope :lab_student_practices, lambda { |lab, topic=nil| 
    if topic.nil? 
      joins(:practices).where("practices.lab_id = ?", lab.id) 
    else
      joins(:practices => :question).where("practices.lab_id = ? AND questions.topic_id = ?", lab.id, topic.id)
    end
  }
  #Correct
  scope :course_student_practices_correct, lambda { |course, topic=nil| 
    if topic.nil?
      joins(:practices).where("practices.course_id = ? AND practices.correct = TRUE", course.id) 
    else
      joins(:practices => :question).where("practices.course_id = ? AND practices.correct = TRUE AND questions.topic_id = ?", course.id, topic.id)
    end
  }
  scope :lab_student_practices_correct, lambda { |lab, topic=nil| 
    if topic.nil?
      joins(:practices).where("practices.lab_id = ? AND practices.correct = TRUE", lab.id) 
    else
      joins(:practices => :question).where("practices.lab_id = ? AND practices.correct = TRUE AND questions.topic_id = ?", lab.id, topic.id)
    end
  }
end