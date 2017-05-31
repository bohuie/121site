class SearchController < ApplicationController

	before_action :authenticate_user!

	def find_questions
		@user = current_user
		@result = Result.new
		@topic = Topic.all
		@users = User.all
		@lab = Array.new
		@users.each do |u|
			if !@lab.include?(u.lab)
				@lab.push(u.lab)
			end
		end
		@fillnames = Question.all
		@fillnames.each do |f|
			@owner = User.find(f.user_id)
			if f.fname.nil?
				f.fname = @owner.fname
			end
			if f.lname.nil?
				f.lname = @owner.lname
			end
			if f.studentnumber.nil?
				f.studentnumber = @owner.studentnumber
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
			@questions = Question.all.order(lname: :asc, fname: :asc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(lname: :asc, fname: :asc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(lname: :asc, fname: :asc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(lname: :asc, fname: :asc)
		end
	end

	def number
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(studentnumber: :asc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(studentnumber: :asc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(studentnumber: :asc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(studentnumber: :asc)
		end
	end

	def lab
		@user = current_user
		@result = Result.new
		@result.name = params[:topic_id]
		@result.lab = params[:lab]
		if (@result.name.eql?("") && @result.lab.eql?(""))
			@questions = Question.all.order(lab: :desc)
		elsif @result.name.eql?("")
			@questions = Question.where(:lab => @result.lab).order(lab: :desc)
		elsif @result.lab.eql?("")
			@questions = Question.where(:topic_id => @result.name).order(lab: :desc)
		else
			@questions = Question.where(:topic_id => @result.name, :lab => @result.lab).order(lab: :desc)
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

	private
		def result_params
			params.require(:result).permit(:name, :lab)
		end
end