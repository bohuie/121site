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
      	@topics = []
      	@labs = []
		@lab = Array.new
		@users.each do |u|
			if !@lab.include?(u.lab)
				@lab.push(u.lab)
			end
		end
	end

	def create
		@user = current_user
		@result = Result.create(result_params)
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(user_id: :desc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(user_id: :desc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(user_id: :desc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(user_id: :desc)
		end
	end

	def name
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.includes(:user).order("users.lname asc", "users.fname asc")
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).includes(:user).order("users.lname asc", "users.fname asc")
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).includes(:user).order("users.lname asc", "users.fname asc")
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).includes(:user).order("users.lname asc", "users.fname asc")
		end
	end

	def number
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.includes(:user).order("users.studentnumber asc")
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).includes(:user).order("users.studentnumber asc")
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).includes(:user).order("users.studentnumber asc")
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).includes(:user).order("users.studentnumber asc")
		end
	end

	def lab
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(lab_id: :desc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(lab_id: :desc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(lab_id: :desc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(lab_id: :desc)
		end
	end
	
	def topic
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(topic_id: :desc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(topic_id: :desc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(topic_id: :desc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(topic_id: :desc)
		end
	end

	def time
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(date_submitted: :desc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(date_submitted: :desc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(date_submitted: :desc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(date_submitted: :desc)
		end
	end

	def grade
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(grade: :asc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(grade: :asc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(grade: :asc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(grade: :asc)
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
			params.require(:result).permit(:name, :lab)
		end
end