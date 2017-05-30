class CoursesController < ApplicationController
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
end
