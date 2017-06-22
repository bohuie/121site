class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      @user = current_user
      if @user.has_role(:instructor)
        @courses = Course.where(instructor_id: @user.id).order(year: :desc)
      else
        @courses = @user.courses
      end
      @games = Game.where(:user_id => @user.user_id)
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
  end

  def terms
    if user_signed_in?
      @user = current_user
    end
  end

   def stats
    if user_signed_in?
      @user = current_user
    end
    @result = Result.new
    @topic = Topic.all
    @users = User.all
    @lab = Array.new
    @users.each do |u|
      if !@lab.include?(u.lab)
        @lab.push(u.lab)
      end
    end
  end

  def view
    if user_signed_in?
      @user = current_user
    end
    @result = Result.new(result_params)
    @users = User.all
    @lab = Array.new
    @users.each do |u|
      if !@lab.include?(u.lab)
        @lab.push(u.lab)
      end
    end 
    @users = User.where(lab: @result.lab)
    if @result.name.empty?
      @topics = Topic.all
    else
      @topics = Topic.find_by(name: @result.name)
    end
    @topic = Topic.all
  end

  private
    def result_params
      params.require(:result).permit(:name, :lab)
    end
end