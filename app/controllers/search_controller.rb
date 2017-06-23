class SearchController < ApplicationController

	before_action :authenticate_user!

	def find_questions
		@user = current_user
		@result = Result.new
		@topic = Topic.all
		@users = User.all
    	@courses = Hash.new
    	if @user.instructor
        	course = Course.where(instructor_id: @user.id).order(year: :desc)
      	elsif @user.assistant
        	course = @user.courses
      	else
        	course = @user.courses
      	end
      	course.each  do |course|
        	@courses[course.title + " - " + course.year] = course.id
      	end
      	@topics = course.first.topics
      	@labs = course.first.labs
		@lab = Array.new
		@users.each do |u|
			if !@lab.include?(u.lab)
				@lab.push(u.lab)
			end
		end
	end

	def display
		@user = current_user
		@result = Result.create(result_params)
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.where(course_created_in: @result.course).order(user_id: :desc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab, course_created_in: @result.course).order(user_id: :desc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name, course_created_in: @result.course).order(user_id: :desc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab, course_created_in: @result.course).order(user_id: :desc)
		end
	end


	def update_search_topics
    	@topics = Course.find(params[:course_id]).topics
    	respond_to do |format|
        	format.js
    	end
  	end

  	def update_search_labs
    	@labs = Course.find(params[:course_id]).labs
    	respond_to do |format|
        	format.js
    	end
  	end

	private
		def result_params
			params.require(:result).permit(:name, :lab, :course_id)
		end
end