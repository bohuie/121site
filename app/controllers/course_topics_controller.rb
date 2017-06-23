class CourseTopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_instructor  , only: [:create, :delete]
  before_action :check_existence_topic, only: [:create]
  before_action :check_existence_course, only: [:create]
  before_action :check_uniqueness_course_topic, only: [:create]
  before_action :check_existence_course_topic, only: [:delete]

  def create
  	@user = current_user
  	course_topic = CourseTopic.new(course_topic_params)
  	if course_topic.save
  		flash[:success] = "Added topic to course."
  		redirect_to topics_path
  	else
  		flash[:warning] = "There was a problem adding that topic to the course.  Try again later or contact an administrator."
  		redirect_to topics_path
  	end
  end

  def delete
  	@course_topic = CourseTopic.find(params[:id])
	if @course_topic.delete
		flash[:success] = "Successfully removed the topic from the course."
  		redirect_to topics_path
  	else
  		flash[:warning] = "There was a problem removing that topic to the course.  Try again later or contact an administrator."
  		redirect_to topics_path
	end
  end

  private

  def course_topic_params
  	params.require(:course_topic).permit(:course_id, :topic_id)
  end

  def check_existence_topic
  	unless Topic.find(params[:course_topic][:topic_id])
  		flash[:warning] = "We couldn't find that topic.  Try again or contact an administrator."
  		redirect_to topics_path
  	end
  end

  def check_existence_course
  	unless Course.find(params[:course_topic][:course_id])
  		flash[:warning] = "We couldn't find that course.  Try again or contact an administrator."
  		redirect_to topics_path
  	end
  end

  def check_uniqueness_course_topic
  	if CourseTopic.where(course_id: params[:course_topic][:course_id], topic_id: params[:course_topic][:topic_id]).count > 0
  		flash[:warning] = "You can only assign a topic to a course once."
  		redirect_to topics_path
  	end
  end

  def check_existence_course_topic
  	byebug
  	unless CourseTopic.find(params[:id])
  		flash[:warning] = "That topic must belong to a course before you can remove it."
  		redirect_to topics_path
  	end
  end
end
