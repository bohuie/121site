class SearchController < ApplicationController

	before_action :authenticate_user!
	before_action :instructor_or_assistant, only: [:display]

	def find_questions
		@user = current_user
		@result = Result.new
    	@courses = Hash.new
    	if @user.has_role?(:instructor)
        	course = Course.where(instructor_id: @user.id).order(year: :desc)
		else
        	course = @user.courses
      	end
      	course.each  do |course|
        	@courses[course.title + " - " + course.year] = course.id
      	end
      	@topics = course.first.topics
      	@labs = course.first.labs
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


	def instructor_or_assistant
		unless current_user.has_role?(:instructor)
			if params[:result][:course_id].nil?
				flash[:warning] = "Your query could not be handled.  Please contact your instructor or try again later."
				redirect_to root_path and return
			end
			course = Course.find(params[:result][:course_id])
			if course.nil?
				flash[:warning] = "Your course-query could not be handled.  Please contact your instructor or try again later."
				redirect_to root_path and return
			end
			unless current_user.has_role?(:assistant, course)
				flash[:warning] = "You must be an instructor or TA to do this."
				redirect_to root_path and return
			end
		end
	end
end