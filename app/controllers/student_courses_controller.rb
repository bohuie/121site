class StudentCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_course_exists, only: [:create]
  before_action :check_course_student_uniqueness, only: [:create]

  def new
  	@user = current_user
  	@student_course = StudentCourse.new
  	@courses = Hash.new
  	Course.all.each do |course|
  		@courses[course.title + " - " + course.year] = course.id
  	end
  end

  def create
  	@user = current_user
  	@student_course = StudentCourse.new(student_course_params)
  	@courses = Hash.new
  	Course.all.each do |course|
  		@courses[course.title + " - " + course.year] = course.id
  	end
  	if @student_course.save
  		flash[:success] = "Thank you for registering for your course."
  		redirect_to show_course_path(@student_course.course)
  	else
  		flash.now[:warning] = "There was an error registering for the course.  Please try again or contact your instructor."
  		render 'new'
  	end
  end

  private

  def student_course_params
  	params.require(:student_course).permit(:user_id, :course_id)
  end

  def check_course_student_uniqueness
  	if current_user.courses.exists?(params[:student_course][:course_id])
  		flash[:warning] = "You can only register for a course once."
  		redirect_to root_path
  	end
  end

  def check_course_exists
  	unless Course.find(params[:student_course][:course_id])
  		flash[:warning] = "That course could not be found.  Please contact your instructor."
  		redirect_to root_path
  	end
  end
end
