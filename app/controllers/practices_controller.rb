class PracticesController < ApplicationController

	def show
		@user = current_user
		@game = Game.new
		@topics = Topic.all
	end

	def create
		@user = current_user
		@game = Game.create
		@game.user_id = @user.user_id
		@game.topic_id = params[:topic_id].to_i
		@game.save
		redirect_to :controller => "practices", :action => "use", :id => @game.game_id
	end

	def submit
		@practice = Practice.new(answer_params)
		@answer = @practice.answer
		@practice = Practice.find_by(id_params)
		@game = Game.find_by(:game_id => @practice.game_id)
		@practice.attempts = @practice.attempts + 1
		@game.number = @game.number + 1
		@game.save
		@practice.save
		puts "ANSWER IS " + @answer.to_s
		puts "IF SAYS THAT " + (Question.find_by(:question_id => @practice.question_id).answer == @answer).to_s
		if Question.find_by(:question_id => @practice.question_id).answer == @answer
			@game.correct = @game.correct + 1
			flash[:success] = "Correct"
			@practice.correct = true
			@practice.save
			@game.save
			redirect_to :controller => "practices", :action => "use", :id => @game.game_id
		else
			flash[:error] = "Incorrect"
			redirect_to :controller => "practices", :action => "use", :id => @game.game_id
		end	
	end

	def use
		@user = current_user
		@practice = nil
		@game = Game.find(params[:id])
		if !@game.nil?
			if @game.topic_id == 0
				@questions = Question.all.to_a
			else
				@questions = Question.where(topic_id: @game.topic_id).to_a
			end
			@i = 0
			while @practice.nil?  && @i < @questions.size do 
				if (Practice.where(:game_id => @game.game_id, :question_id => 
					@questions[@i].question_id, :correct => true).nil? ||
					Practice.where(:game_id => @game.game_id, :question_id => 
						@questions[@i].question_id, :correct => true).empty?)
					if @questions[@i].submitted == true
						@practice = Practice.create
						@practice.game_id = @game.game_id
						@practice.user_id = @user.user_id
						@practice.question_id = @questions[@i].question_id
						@practice.topic_id = @questions[@i].topic_id
						@practice.save
					end
				else
					@i = @i + 1 
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
	def id_params
		params.require(:practice).permit(:practice_id)
	end
end