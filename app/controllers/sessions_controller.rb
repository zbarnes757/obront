class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      if @user.admin?
        redirect_to admin_index_path
      else
        redirect_to user_path
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    session.delete(:current_user)
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
