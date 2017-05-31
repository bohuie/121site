class CoursesController < ApplicationController

  before_action :authenticate_user!
  before_action :check_instructor  , only: [:new, :create]
  before_action :check_student_belongs, only: [:show]

  def new
    @user = current_user
    @course = Course.new
  end

  def create
    @user = current_user
    @course = Course.new(course_params)
    @course.instructor = current_user
    if @course.save
      redirect_to show_course_path(@course)
    else
      flash.now[:warning] = "There was an error creating your course."
      render 'new'
    end
  end

  def show
  	if user_signed_in?
      @user = current_user
      @course = Course.find(params[:id])
      if @user.instructor
        @courses = Course.where(instructor_id: @user.id).order(year: :desc)
      elsif @user.assistant
      	@courses = @user.courses
        @lab = @course.labs.includes(:student_labs).where("student_labs.user_id = ?",@user.id).references(:student_labs).first
      else
        @courses = @user.courses
        @lab = @course.labs.includes(:student_labs).where("student_labs.user_id = ?",@user.id).references(:student_labs).first
      end
      @games = Game.where(:user_id => @user.user_id, course_id: params[:id])
      @count = @games.count
      @number = 0
      @percent = 0
      @games.each do |g|
        if !(g.number == 0)
          if((g.correct*100/g.number*100)/100) > @percent
            @percent = ((g.correct*100/g.number*100)/100)
            @number = g.number
          elsif ((g.correct*100/g.number*100)/100) == @percent
            if g.number > @number
              @number = g.number
            end
          end
        end
      end
    end
    @topics = Topic.where(course_id: params[:id])
    @created = Question.where(course_id: params[:id]).count
    @submitted = Question.where(submitted: true, course_id: params[:id]).count
  end

  private

  def course_params # Restricts parameters
    params.require(:course).permit(:title, :subject, :year, :instructor_id)
  end

  def check_student_belongs
    unless  current_user.has_role?(:instructor)
      unless current_user.courses.exists?(params[:id])
        flash[:warning] = "You must register for a course before you can view it."
        redirect_to root_path
      end
    end
  end

  def check_instructor # Checks current user is an instructor
    if !current_user.has_role? :instructor
      flash[:danger] = 'Instructors only.'
      redirect_to root_path
    end
  end
end
