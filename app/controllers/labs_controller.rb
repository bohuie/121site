class LabsController < ApplicationController

  before_action :authenticate_user!
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
    @games = Game.where(:user_id => @user.user_id, course_id: @lab.course_id)
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
    @topics = @lab.course.topics
    @created = @lab.questions.includes(:courses).where("courses.id = ?",1).references(:courses).count
    @submitted = @lab.questions.includes(:courses).where("courses.id = ? AND questions.submitted = true",1).references(:courses).count
  	#@created = @lab.course.questions.count
    #@submitted = Question.where(submitted: true, course_id:  @lab.course.id, lab_id: @lab.id).count
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
