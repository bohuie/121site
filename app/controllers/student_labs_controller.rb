class StudentLabsController < ApplicationController

  before_action :authenticate_user!

  def new
  	@user = current_user
    @student_lab = StudentLab.new
  end

  def create
  	@user = current_user

  end
end
