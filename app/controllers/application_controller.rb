class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_admin_login
    unless current_user && current_user.admin?
      redirect_to new_session_path and return
    end
  end

  def require_login
    unless current_user
      redirect_to new_session_path and return
    end
  end

end
