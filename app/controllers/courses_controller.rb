class CoursesController < ApplicationController

  before_action :authenticate_user!
  before_action :check_instructor  , only: [:new, :create, :manage, :add_ta, :remove_ta]
  before_action :check_student_belongs, only: [:show]
  before_action :check_course_exists, only: [:manage, :add_ta, :remove_ta]

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
        @labs = @course.labs.includes(:student_labs).where("student_labs.user_id = ?",@user.id).references(:student_labs)
      else
        @courses = @user.courses
        @labs = @course.labs.includes(:student_labs).where("student_labs.user_id = ?",@user.id).references(:student_labs)
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
    @topics = @course.topics
  end

  def manage
    @course = Course.find(params[:id])
    @user = current_user
    @students = User.with_any_role({name: :student, resource: @course}, {name: :assistant, resource: @course})
  end

  def add_ta
    @user = current_user
    @course = Course.find(params[:id])
    @student = User.find(params[:student])
    if @student.nil?
      flash[:warning] = "That student could not be found.  Try again later."
      redirect_to root_path and return
    else
      if @student.has_role?(:assistant, @course)
        flash[:warning] = "That student is already a TA for this course."
        redirect_to root_path and return
      else
        @student.add_role(:assistant, @course)
        @student.remove_role(:student, @course)
        @student.save
        flash[:success] = "Student has been added as a TA."
        redirect_to manage_ta_path
      end
    end
  end

  def remove_ta
    @user = current_user
    @course = Course.find(params[:id])
    @student = User.find(params[:student])
    if @student.nil?
      flash[:warning] = "That student could not be found.  Try again later."
      redirect_to root_path and return
    else
      if @student.has_role?(:student, @course)
        flash[:warning] = "That student is not a TA for this course."
        redirect_to root_path and return
      else
        @student.add_role(:student, @course)
        @student.remove_role(:assistant, @course)
        @student.save
        flash[:success] = "Student is no longer a TA."
        redirect_to manage_ta_path
      end
    end
  end

  private
  def course_params # Restricts parameters
    params.require(:course).permit(:title, :subject, :year, :instructor_id)
  end

  def check_course_exists
    course = Course.find(params[:id])
    if course.nil?
      flash[:warning] = "That course could not be found.  Try again later."
      redirect_to root_path
    end
  end

  def check_student_belongs
    unless  current_user.has_role?(:instructor)
      unless current_user.courses.exists?(params[:id])
        flash[:warning] = "You must register for a course before you can view it."
        redirect_to root_path
      end
    end
  end
end
