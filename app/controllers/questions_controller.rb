class QuestionsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_instructor, only: [:flag_questions, :display_flag_questions]
  before_action :instructor_or_assistant, only: [:display_mark_questions]

  def correct
    @user = current_user
    @question = Question.find(params[:question][:id])
    if @user.has_role?(:instructor) || @user.has_role?(:assistant, @question.course_created_in)
      @question.update_attribute(:grade, "Correct")
      @questions = Question.where(:topic_id => @question.topic_id, :lab => @question.lab)
      @result = Result.create(:name => @question.topic_id, :lab => @question.lab)
    else
      @questions = nil
    end
  end

  def view
    @user = current_user
    @question = Question.find(params[:id])
  end

  def mark
    @user = current_user
    @question = Question.find(params[:id])
  end

  def flagview
    @user = current_user
    @question = Question.find(params[:id])
  end

  def incorrect
    @user = current_user
    @question = Question.find(params[:question][:id])
    if @user.has_role?(:instructor) || @user.has_role?(:assistant, @question.course_created_in)
      @question.update_attribute(:grade, "Incorrect")
      @questions = Question.where(:topic_id => @question.topic_id, :lab => @question.lab)
      @result = Result.create(:name => @question.topic_id, :lab => @question.lab)
    else
      @questions = nil
    end
  end

  def changes
    @user = current_user
    @question = Question.find(params[:id])
  end

  def comment
    @user = current_user
      @question = Question.find(params[:question][:id])
    if @user.has_role?(:instructor) || @user.has_role?(:assistant, @question.course_created_in)
      @question.update_attributes(grade_params)
      @question.grade = "Marker comment: " + @question.grade.to_s
      @question.save
      @questions = Question.where(:topic_id => @question.topic_id, :lab => @question.lab)
      @result = Result.create(:name => @question.topic_id, :lab => @question.lab)
    else
      @questions = nil
    end
  end

  def your_questions
    @user = current_user
    @questions = Question.where(user_id: current_user.user_id)
  end

  def flag_questions
    @user = current_user
    @courses = Hash.new
    course = Course.where(instructor_id: @user.id).order(year: :desc)
    course.each  do |course|
      @courses[course.title + " - " + course.year] = course.id
    end
    @topics = course.first.topics
    @labs = course.first.labs
    @result = Result.new
  end

  def display_flag_questions
    @user = current_user
    @result = Result.new(result_params)
    if (@result.name.eql?("") && @result.lab.eql?(""))
      @questions = Question.where(course_created_in: @result.course, submitted: true).order(user_id: :desc)
    elsif @result.name.eql?("")
      @questions = Question.where(:lab => @result.lab, course_created_in: @result.course, submitted: true).order(user_id: :desc)
    elsif @result.lab.eql?("")
      @questions = Question.where(:topic_id => @result.name, course_created_in: @result.course, submitted: true).order(user_id: :desc)
    else
      @questions = Question.where(:topic_id => @result.name, :lab => @result.lab, course_created_in: @result.course, submitted: true).order(user_id: :desc)
    end
  end

  def mark_questions
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

  def display_mark_questions
    @user = current_user
    @result = Result.new(result_params)
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

  def submit
    @user = current_user
    @question = Question.find_by(id: params[:id])
    @question.update_attribute(:submitted, true)
    @question.update_attribute(:grade, "Review Pending")
    @question.update_attribute(:date_submitted, (DateTime.now.to_time - 8.hours).to_datetime)
    redirect_to "/your_questions"
  end

  def hide
    @user = current_user
    @question = Question.find_by(id: params[:id])
    @question.update_attribute(:visible, false)
    redirect_to "/your_questions"
  end

  def edit
    @user = current_user
    @question = Question.find(params[:id])
    @topic = Topic.all
    @answer = ['a', 'b', 'c', 'd', 'e']
  end

  def update
    @user = current_user
    @question = Question.find(params[:id])
    @question.update_attributes(question_params)
    @answer = answer_params.to_s
      if @answer[12, @answer.length - 14] == "a"
        @question.answer = 1
      elsif @answer[12, @answer.length - 14] == "b"
        @question.answer = 2
      elsif @answer[12, @answer.length - 14] == "c"
        @question.answer = 3
      elsif @answer[12, @answer.length - 14] == "d"
        @question.answer = 4
      elsif @answer[12, @answer.length - 14] == "e"
        @question.answer = 5
      end
    @question.save
    redirect_to "/your_questions"
  end

  def new
    @user = current_user
    @userID = current_user.user_id
    @question = Question.new
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
    @topic = Topic.all
    @answer = ['a', 'b', 'c', 'd', 'e']
  end

  def create
    @user = current_user
	  if user_signed_in?
	    @question = Question.new(question_params)
	    @question.user_id = current_user.user_id
      unless @user.labs.where('labs.course_id = ?',params[:question][:course_created_in]).count == 0 
        @question.lab = @user.labs.where('labs.course_id = ?',params[:question][:course_created_in]).first
        @question.course_created_in = Course.find(params[:question][:course_created_in])
      else
        if @user.has_role?(:instructor)
          @question.course_created_in = Course.find(params[:question][:course_created_in])
        else
          flash[:warning] = "Please select a valid lab"
          redirect_to new_questions_path and return
        end
      end
      @answer = answer_params.to_s
      if @answer[12, @answer.length - 14] == "a"
        @question.answer = 1
      elsif @answer[12, @answer.length - 14] == "b"
        @question.answer = 2
	    elsif @answer[12, @answer.length - 14] == "c"
        @question.answer = 3
      elsif @answer[12, @answer.length - 14] == "d"
        @question.answer = 4
      elsif @answer[12, @answer.length - 14] == "e"
        @question.answer = 5
      end
      @question.submitted = !(params[:submitted].to_s.include? "Create")
      if @question.save
        if @question.submitted
          @question.grade = "Review Pending"
          @question.date_submitted = (DateTime.now.to_time - 8.hours).to_datetime
          @question.save
	        flash[:success] = "Question submitted!"
        else
          flash[:success] = "Question created!"
        end
	      redirect_to "/your_questions"
	    else
	      flash[:error] = "Please fill in all required fields."
        redirect_to "/questions/new"
	    end
	  end
  end

  def update_question_topics
    @topics = Course.find(params[:course_id]).topics
    respond_to do |format|
        format.js
    end
  end

  def update_question_labs
    @labs = Course.find(params[:course_id]).labs
    respond_to do |format|
      format.js
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

  def question_params
    params.require(:question).permit(:qtext, :a1text, :a2text, :a3text, :a4text, :a5text, :topic_id, :submitted)
  end

  def answer_params
    params.require(:question).permit(:answer)
  end

  def id_params
    params.require(:question).permit(:question_id)
  end

  def grade_params
    params.require(:question).permit(:grade)
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