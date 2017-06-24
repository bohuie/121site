class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_filter :catch_not_found

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      @courses = Course.all
      devise_parameter_sanitizer.permit(:sign_up) do |u|
        u.permit :username, :email, :password, :password_confirmation, :fname, :lname, :courses, :studentnumber
      end
    end
  
   private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def catch_not_found
    yield
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "There was an error with your search.  Please try again later, or contact an administrator."
      redirect_back_or root_url
  end

  def check_instructor # Checks current user is an instructor
    if !current_user.has_role? :instructor
      flash[:danger] = 'Instructors only.'
      redirect_to root_path
    end
  end

end
