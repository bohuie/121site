class PracticesController < ApplicationController
	ActionController::Parameters.action_on_unpermitted_parameters = false

	before_action :authenticate_user!
	
	def show
		@user = current_user
		@game = Game.new
		@topics = []
		@courses = Hash.new
		if @user.has_role?(:instructor)
        	course = Course.where(instructor_id: @user.id).order(year: :desc)
     	else
        	course = @user.courses
      	end
  		course.each do |course|
  			@courses[course.title + " - " + course.year] = course.id
  		end
	end

	def create
		@user = current_user
		@game = Game.create(game_params)
		@game.user_id = @user.id
		@game.topic_id = topic_params.to_s[10, topic_params.to_s.length-12].to_i
		#@game.course_id = params[:game][:course_id]
		if @game.save
			redirect_to :controller => "practices", :action => "use", :id => @game.id
		else
			flash[:warning] = "Please select a course from the drop down."
			redirect_to :controller => "practices", :action => "show"
		end
	end

	def submit
		@practice = Practice.find(params[:practice][:id])
		@game = Game.find(@practice.game_id)
		@practice.attempts = @practice.attempts + 1
		@practice.starttime = params[:practice][:starttime]
		@practice.endtime = DateTime.now
		@practice.totaltime = ((@practice.endtime-@practice.starttime)/1.second).to_i
		@game.number = @game.number + 1
		@game.save
		@practice.course_id = @game.course_id
		if current_user.labs.where(course_id: @game.course_id).first
			@practice.lab_id = current_user.labs.where(course_id: @game.course_id).first.id
		else
			@practice.lab_id = 0
		end
		@practice.save
		if Question.find(@practice.question_id).answer == params[:practice][:answer].to_i
			@game.correct = @game.correct + 1
			flash[:success] = "Correct"
			@practice.correct = true
			@practice.save
			@game.save
			redirect_to :controller => "practices", :action => "use", :id => @game.id
		else
			flash[:error] = "Incorrect"
			redirect_to :controller => "practices", :action => "incorrect", :gameid => @game.id, :questionid => Question.find(@practice.question_id).id
		end	
	end

	def incorrect
		@user = current_user
		@practice = nil
		@game = Game.find(params[:gameid])
		@question = Question.find(params[:questionid])
	end

	def use
		@user = current_user
		@practice = nil
		@game = Game.find(params[:id])
		if !@game.nil?
			if @game.topic_id == 0
				@questions = @game.course.questions
			else
				@questions = @game.topic.questions
			end
			@i = 0
			@questions.each do |q| 
				if (Practice.where(:game_id => @game.id, :question_id => q.id).nil? ||
					Practice.where(:game_id => @game.id, :question_id => q.id).empty? )
					if (q.submitted == true && q.grade == "Correct")
						@practice = Practice.create
						@practice.game_id = @game.id
						@practice.user_id = @user.id
						@practice.question_id = q.id
						#@practice.topic_id = q.topic_id
						@practice.save
						break
					end
				end
			end
			if !@practice.nil?
				@question = Practice.find(@practice.id)
			end
		end
		@current = Practice.new
	end

	def update_practice_topics
    	@topics = Course.find(params[:course_id]).topics
    	respond_to do |format|
      		format.js
    	end
  	end

	private 

	def game_params
		params.require(:game).permit(:topic_id, :course_id)
	end
	def answer_params
		params.require(:practice).permit(:answer)
	end
	def topic_params
		params.require(:game).permit(:name)
	end
	def start_params
		params.require(:practice).permit(:starttime)
	end
	def id_params
		params.require(:practice).permit(:id)
	end
end