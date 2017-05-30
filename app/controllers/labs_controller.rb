class LabsController < ApplicationController

  before_action :check_instructor, only: [:new, :create]
  before_action :check_owner, only: [:new]
  def new
  	@user = current_user
  	@lab = Lab.new
  end

  def create
  	@user = current_user
  	@lab = Lab.new(lab_params)	
  	if @lab.save
  		redirect_to show_lab_path(@lab)
  	else
  		flash.now[:warning] = "There was an error creating your lab."
  		render 'new'
    end
  end

  def show
  	@user = current_user
  	@lab = Lab.find(params[:id])
  	if @user.instructor
        @courses = Course.where(instructor_id: @user.id).order(year: :desc)
    elsif @user.assistant
      	@courses = @user.courses
    else
        @courses = @user.courses
    end
    @topics = Topic.where(course_id: @lab.course_id)
  	@created = Question.where(course_id: @lab.course.id, lab_id: @lab.id).count
    @submitted = Question.where(submitted: true, course_id:  @lab.course.id, lab_id: @lab.id).count
  end

  private

  def lab_params # Restricts parameters
    params.require(:lab).permit(:name, :course_id)
  end

  def check_instructor # Checks current user is an instructor
    if !current_user.has_role? :instructor
      flash[:danger] = 'Instructors only.'
      redirect_to root_path
    end
  end

  def check_owner
  	if Course.find(params[:course_id]).instructor != current_user
  		flash[:danger] = 'You can only make changes to your courses.'
  		redirect_to root_path
  	end
  end
end
