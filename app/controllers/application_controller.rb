class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
