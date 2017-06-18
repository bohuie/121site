class TopicsController < ApplicationController
	def show
		@user = current_user
		@topic = Topic.new
		@topics = Topic.all
		@ct = Topic.new #dummy variable for a simple form drop down
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

    	@course_topics = []
	end

	def create
		@user = current_user
		if @user.assistant || @user.instructor
			@topic = Topic.create(topic_params)
			if @topic.save
				flash[:success] = "Topic created"
			else
				flash[:error] = "Please fill in the field"
			end
		end
		redirect_to "/topics"
	end

	def remove
		@user = current_user
		if @user.assistant || @user.instructor
			@topic = Topic.find_by(topic_id: params[:id])
			if(!@topic.nil?)
				@topic.delete
			end
		end
		redirect_to "/topics"
	end
	def update_course_topics
		@course = Course.find(params[:course_id])
    	@course_topics = @course.topics
    	@course_topic = CourseTopic.new
    	@topics = Topic.all
    	respond_to do |format|
        	format.js
    	end
  	end

	private 

	def topic_params
		params.require(:topic).permit(:name)
	end
end