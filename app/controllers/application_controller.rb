class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def freelancer_board
    Trello::Board.find(ENV['FREELANCER_BOARD'])
  end

  def available_label
    Trello::Label.find(ENV['AVAILABLE_LABEL'])
  end

  def not_available_label
    Trello::Label.find(ENV['NOT_AVAILABLE_LABEL'])
  end

  def get_card(card_id)
    Trello::Card.find(card_id)
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
