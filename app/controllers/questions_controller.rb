class QuestionsController < ApplicationController

  before_action :authenticate_user!

  def correct
    @user = current_user
    if @user.assistant || @user.instructor
      @question = Question.find_by(id: params[:id])
      @question.update_attribute(:grade, "Correct")
      @questions = Question.where(:topic_id => @question.topic_id, :lab => @question.lab)
      @result = Result.create(:name => @question.topic_id, :lab => @question.lab)
    else
      @questions = nil
    end
  end

  def view
    @user = current_user
    @question = Question.find_by(id: params[:id])
  end

  def mark
    @user = current_user
    @question = Question.find_by(id: params[:id])
  end

  def flagview
    @user = current_user
    @question = Question.find_by(id: params[:id])
  end

  def incorrect
    @user = current_user
    if @user.assistant || @user.instructor
      @question = Question.find_by(id: params[:id])
      @question.update_attribute(:grade, "Incorrect")
      @questions = Question.where(:topic_id => @question.topic_id, :lab => @question.lab)
      @result = Result.create(:name => @question.topic_id, :lab => @question.lab)
    else
      @questions = nil
    end
  end

  def changes
    @user = current_user
    @question = Question.find_by(id: params[:id])
  end

  def comment
    @user = current_user
    if @user.assistant || @user.instructor
      @question = Question.find_by(id_params)
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
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    if @user.instructor
      @questions = Question.where(submitted: true).paginate(page: params[:page])  
    else
      @questions = nil
    end
  end

  def flag
    @user = current_user
    if @user.instructor
      @question = Question.find_by(id: params[:id])
      @question.update_attribute(:exam, true)
    end
    if $name
      redirect_to '/flagname'
    elsif $number
      redirect_to '/flagnumber'
    elsif $topic
      redirect_to '/flagtopic'
    elsif $lab
      redirect_to '/flaglab'
    elsif $flagged
      redirect_to '/flagexam'
    elsif $time
      redirect_to '/flagtime'
    elsif $grade
      redirect_to '/flaggrade'
    else
      redirect_to '/flag_questions'
    end
  end

   def unflag
    @user = current_user
    if @user.instructor
      @question = Question.find_by(id: params[:id])
      @question.update_attribute(:exam, false)
    end
    if $name
      redirect_to '/flagname'
    elsif $number
      redirect_to '/flagnumber'
    elsif $topic
      redirect_to '/flagtopic'
    elsif $lab
      redirect_to '/flaglab'
    elsif $flagged
      redirect_to '/flagexam'
    elsif $time
      redirect_to '/flagtime'
    elsif $grade
      redirect_to '/flaggrade'
    else
      redirect_to '/flag_questions'
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
      unless @user.labs.where('labs.course_id = ?',params[:question][:course_id]).count == 0
        @question.lab = @user.labs.where('labs.course_id = ?',params[:question][:course_id]).first
        @question.course_created_in = @question.lab.course
      else
        flash[:warning] = "Please select a valid lab"
        redirect_to new_questions_path
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

  def name
    @user = current_user
    @questions = Question.all.order(lname: :asc, fname: :asc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $name = true
  end

  def number
    @user = current_user
    @questions = Question.all.order(studentnumber: :asc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $number = true
  end

  def lab
    @user = current_user
    @questions = Question.all.order(lab: :desc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $lab = true
  end
  
  def topic
    @user = current_user
    @questions = Question.all.order(topic_id: :desc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $topic = true
  end

  def time
    @user = current_user
    @questions = Question.all.order(date_submitted: :desc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $time = true
  end

  def flagged
    @user = current_user
    @questions = Question.all.order(exam: :desc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $flagged = true
  end

  def grade
    @user = current_user
    @questions = Question.all.order(grade: :asc).paginate(page: params[:page])
    $name = false
    $number = false
    $topic = false
    $lab = false
    $time = false
    $flagged = false
    $grade = false
    $grade = true
  end

  def update_question_topics
    @topics = Course.find(params[:course_id]).topics
    respond_to do |format|
        format.js
    end
  end

   private
    
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
end