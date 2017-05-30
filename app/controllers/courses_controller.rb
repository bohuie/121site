class CoursesController < ApplicationController

  before_action :check_instructor  , only: [:new]

  def new
    @user = current_user
    @course = Course.new
  end

  def create
    @user = current_user
    @course = Course.new(course_params)
    if @course.save
      redirect_to course_path(@course)
    else
      flash.now[:warning] = "There was an error creating your course."
      render 'new'
    end
  end

  def show
  	if user_signed_in?
      @user = current_user
      if @user.instructor
        @courses = Course.where(instructor_id: @user.id)
      elsif @user.assistant
      	@courses = @user.courses
      else
        @courses = @user.courses
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
    @course = Course.find(params[:id])
    @topics = Topic.where(course_id: params[:id])
    @created = Question.where(course_id: params[:id]).count
    @submitted = Question.where(submitted: true, course_id: params[:id]).count
  end

  private

  def course_params # Restricts parameters
    params.require(:course).permit(:title, :subject)
  end

  def check_instructor # Checks current user is an instructor
    if !current_user.has_role? :instructor
      flash[:danger] = 'Instructors only.'
      redirect_to root_path
    end
  end
end
