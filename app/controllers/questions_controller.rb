class QuestionsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_instructor, only: [:flag_questions, :set_flag_questions, :display_flag_questions, :flag, :unflag]
  before_action :instructor_or_assistant, only: [:display_mark_questions]

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

  def changes
    @user = current_user
    @question = Question.find(params[:id])
  end

  def your_questions
    @user = current_user
    @questions = Question.where(user_id: current_user.user_id)
  end

  def flag
    @user = current_user
    @question = Question.find(params[:id])
    if @user.has_role?(:instructor)
      @question.update_attribute(:exam, true)
    end

    redirect_to display_flag_questions_path
  end

  def unflag
    @user = current_user
    @question = Question.find(params[:id])
    if @user.has_role?(:instructor)
      @question.update_attribute(:exam, false)
    end

    redirect_to display_flag_questions_path
  end

  def correct
    @user = current_user
    @question = Question.find(params[:id])
    if @user.has_role?(:instructor) || @user.has_role?(:assistant, @question.course_created_in)
      @question.update_attribute(:grade, "Correct")
      params[:result][:course_id] = session[:mark_questions_course_id]
      params[:result][:name] = session[:mark_questions_topic]
      params[:result][:lab] = session[:mark_questions_lab]
      redirect_to display_mark_questions_path
    else
      @questions = nil
    end
  end

  def incorrect
    @user = current_user
    @question = Question.find(params[:id])
    if @user.has_role?(:instructor) || @user.has_role?(:assistant, @question.course_created_in)
      @question.update_attribute(:grade, "Incorrect")
      params[:result][:course_id] = session[:mark_questions_course_id]
      params[:result][:name] = session[:mark_questions_topic]
      params[:result][:lab] = session[:mark_questions_lab]
      redirect_to display_mark_questions_path
    else
      @questions = nil
    end
  end

  def comment
    @user = current_user
      @question = Question.find(params[:question][:id])
    if @user.has_role?(:instructor) || @user.has_role?(:assistant, @question.course_created_in)
      @question.update_attributes(grade_params)
      @question.grade = "Marker comment: " + @question.grade.to_s
      @question.save
      params[:result][:course_id] = session[:mark_questions_course_id]
      params[:result][:name] = session[:mark_questions_topic]
      params[:result][:lab] = session[:mark_questions_lab]
      redirect_to display_mark_questions_path
    else
      @questions = nil
    end
  end

  def flag_questions
    @user = current_user
    @result = Result.new
    @courses = Hash.new
    course = Course.where(instructor_id: @user.id).order(year: :desc)
    course.each  do |course|
      @courses[course.title + " - " + course.year] = course.id
    end
     if defined?(session[:flag_questions_course_id]) && !session[:flag_questions_course_id].blank?
      if course.find(session[:flag_questions_course_id]).nil?
        @topics = course.first.topics
        @labs = course.first.labs
      else
        @topics = course.find(session[:flag_questions_course_id]).topics
        @labs = course.find(session[:flag_questions_course_id]).labs
      end
    else
      @topics = course.first.topics
      @labs = course.first.labs
    end
  end

  def set_flag_questions
    @result = Result.new(result_params)
    session[:flag_questions_course_id] = @result.course_id
    session[:flag_questions_lab] = @result.lab
    session[:flag_questions_topic] = @result.name
    redirect_to display_flag_questions_path
  end

  def display_flag_questions
    @user = current_user
    if (session[:flag_questions_topic].eql?("") && session[:flag_questions_lab].eql?(""))
      @questions = Question.where(course_created_in: session[:flag_questions_course_id], submitted: true).order(user_id: :desc)
    elsif session[:flag_questions_topic].eql?("")
      @questions = Question.where(:lab => session[:flag_questions_lab], course_created_in: session[:flag_questions_course_id], submitted: true).order(user_id: :desc)
    elsif session[:flag_questions_lab].eql?("")
      @questions = Question.where(:topic_id => session[:flag_questions_topic], course_created_in: session[:flag_questions_course_id], submitted: true).order(user_id: :desc)
    else
      @questions = Question.where(:topic_id => session[:flag_questions_topic], :lab => session[:flag_questions_lab], course_created_in: session[:flag_questions_course_id], submitted: true).order(user_id: :desc)
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
    if defined?(session[:mark_questions_course_id]) && !session[:mark_questions_course_id].blank?
      if course.find(session[:mark_questions_course_id]).nil?
        @topics = course.first.topics
        @labs = course.first.labs
      else
        @topics = course.find(session[:mark_questions_course_id]).topics
        @labs = course.find(session[:mark_questions_course_id]).labs
      end
    else
      @topics = course.first.topics
      @labs = course.first.labs
    end
  end

  def set_mark_questions
    @result = Result.new(result_params)
    session[:mark_questions_course_id] = @result.course_id
    session[:mark_questions_lab] = @result.lab
    session[:mark_questions_topic] = @result.name
    redirect_to display_mark_questions_path
  end

  def display_mark_questions
    @user = current_user
    if (session[:mark_questions_topic].eql?("") && session[:mark_questions_lab].eql?(""))
      @questions = Question.where(course_created_in: session[:mark_questions_course_id]).order(user_id: :desc)
    elsif session[:mark_questions_topic].eql?("")
      @questions = Question.where(:lab => session[:mark_questions_lab], course_created_in: session[:mark_questions_course_id]).order(user_id: :desc)
    elsif session[:mark_questions_lab].eql?("")
      @questions = Question.where(:topic_id => session[:mark_questions_topic], course_created_in: session[:mark_questions_course_id]).order(user_id: :desc)
    else
      @questions = Question.where(:topic_id => session[:mark_questions_topic], :lab => session[:mark_questions_lab], course_created_in: session[:mark_questions_course_id]).order(user_id: :desc)
    end
  end

  def submit
    @user = current_user
    @question = Question.find(params[:id])
    @question.update_attribute(:submitted, true)
    @question.update_attribute(:grade, "Review Pending")
    @question.update_attribute(:date_submitted, (DateTime.now.to_time - 8.hours).to_datetime)
    redirect_to "/your_questions"
  end

  def hide
    @user = current_user
    @question = Question.find(params[:id])
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
      if session[:mark_questions_course_id].nil?
        flash[:warning] = "Your query could not be handled.  Please contact your instructor or try again later."
        redirect_to root_path and return
      end
      course = Course.find(session[:mark_questions_course_id])
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