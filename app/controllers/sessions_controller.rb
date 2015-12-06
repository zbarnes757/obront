class SessionsController < ApplicationController

  def new
    if current_user && current_user.admin?
      redirect_to admin_index_path
    elsif current_user && current_user.admin == false
      redirect_to user_path(current_user)
    end
  end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      if @user.admin?
        redirect_to admin_index_path
      else
        redirect_to user_path(@user)
      end
    else
      redirect_to new_session_path, alert: "You could not be signed in. Try again."
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, alert: "You have been logged out."
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
