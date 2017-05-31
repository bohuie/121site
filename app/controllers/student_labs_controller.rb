class StudentLabsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_course_lab_student_uniqueness, only: [:create]
  before_action :check_course_exists, only: [:create]
  before_action :check_lab_exists, only: [:create]

  def new
  	@user = current_user
  	@course = Course.find(params[:course_id])
  	@labs = @course.labs
    @student_lab = StudentLab.new
  end

  def create
  	@user = current_user
  	@course = Course.find(params[:student_lab][:course_id])
  	@labs = @course.labs
  	@student_lab = StudentLab.new(student_lab_params)

  	if @student_lab.save
  		flash[:success] = "Thank you for registering for your lab."
  		redirect_to show_lab_path(@student_lab.lab)
  	else
  		flash.now[:warning] = "There was an error registering for the lab.  Please try again or contact your instructor."
  		render 'new'
  	end
  end

  private

  def student_lab_params
  	params.require(:student_lab).permit(:user_id, :lab_id)
  end

  def check_course_lab_student_uniqueness
  	course = Course.find(params[:student_lab][:course_id])
  	unless course.labs.includes(:student_labs).where("student_labs.user_id = ?", params[:student_lab][:user_id]).references(:student_labs).first.nil?
  		flash[:warning] = "You can only register for one lab in each course."
  		redirect_to root_path
  	end
  end

  def check_course_exists
  	course = Course.find(params[:student_lab][:course_id])
  	if course.nil?
  		flash[:warning] = "That course could not be found.  Please contact your instructor."
  		redirect_to root_path
  	end
  end

  def check_lab_exists
  	course = Course.find(params[:student_lab][:course_id])
  	lab = course.labs.where(id: params[:student_lab][:lab_id]).first
  	if lab.nil?
  		flash[:warning] = "That lab could not be found.  Please contact your instructor."
  		redirect_to root_path
  	end
  end
end
