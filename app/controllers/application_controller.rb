class ApplicationController < ActionController::Base
  protect_from_forgery

  protected


  def confirm_logged_in_admin
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'access', :action => 'login')
      return false # halts the before_filter
    else
        if session[:type] == "Student"
          redirect_to(:controller => 'students', :action => 'index')
        end
        if session[:type] == "Teacher"
          flash[:notice] = "Section restricted for teachers."
          redirect_to(courses_path)
        end
    end
  end

  def confirm_logged_in_teacher
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'access', :action => 'login')
      return false # halts the before_filter
    else
        if session[:type] == "Student"
          redirect_to(:controller => 'students', :action => 'index')
        end
    end
  end

    def confirm_logged_in_student
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'access', :action => 'login')
      return false # halts the before_filter
    else
        if session[:type] == "Teacher"
          flash[:notice] = "Only students get the dashboard!"
          redirect_to(:controller => 'access', :action => 'menu')
        end
        if session[:type] == "Admin"
          flash[:notice] = "Only students get the dashboard!"
          redirect_to(:controller => 'access', :action => 'menu')
        end
      end
  end

end
