class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset if user
    redirect_to root_path, notice: "Email sent with password reset instructions."
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: "Password reset has expired."
    elsif @user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      redirect_to root_url, notice: "Password has been reset!"
    else
      flash[:errors] = @user.errors.full_messages
      render :edit
    end
  end
end
