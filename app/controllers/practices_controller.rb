class PracticesController < ApplicationController

	before_action :authenticate_user!
	
	def show
		@user = current_user
		@game = Game.new
		@topics = Topic.all
	end

	def create
		@user = current_user
		@game = Game.create
		@game.user_id = @user.user_id
		@game.topic_id = topic_params.to_s[10, topic_params.to_s.length-12].to_i
		@game.save
		redirect_to :controller => "practices", :action => "use", :id => @game.game_id
	end

	def submit
		@practice = Practice.new(answer_params)
		@answer = @practice.answer
		@practice = Practice.new(start_params)
		@start = @practice.starttime
		@practice = Practice.find_by(id_params)
		@game = Game.find_by(:game_id => @practice.game_id)
		@practice.attempts = @practice.attempts + 1
		@practice.starttime = @start
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
		if Question.find_by(:question_id => @practice.question_id).answer == @answer
			@game.correct = @game.correct + 1
			flash[:success] = "Correct"
			@practice.correct = true
			@practice.save
			@game.save
			redirect_to :controller => "practices", :action => "use", :id => @game.game_id
		else
			flash[:error] = "Incorrect"
			redirect_to :controller => "practices", :action => "incorrect", :gameid => @game.game_id, :questionid => Question.find_by(:question_id => @practice.question_id).id
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
				@questions = Question.all.to_a
			else
				@questions = Question.where(topic_id: @game.topic_id)
			end
			@i = 0
			@questions.each do |q| 
				if (Practice.where(:game_id => @game.game_id, :question_id => 
					q.question_id).nil? ||
					Practice.where(:game_id => @game.game_id, :question_id => 
						q.question_id).empty?)
					if (q.submitted == true && q.grade == "Correct")
						@practice = Practice.create
						@practice.game_id = @game.game_id
						@practice.user_id = @user.user_id
						@practice.question_id = q.question_id
						#@practice.topic_id = q.topic_id
						@practice.save
						break
					end
				end
			end
			if !@practice.nil?
				@question = Practice.where(:practice_id => @practice.practice_id)
			end
		end
		@current = Practice.new
	end

	private 

	def game_params
		params.require(:game).permit(:topic_id)
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
		params.require(:practice).permit(:practice_id)
	end
end