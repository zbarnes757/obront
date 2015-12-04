class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update, :show]
  before_action :require_admin_login, only: [:new, :create, :destroy]

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_index_path
    else
      render :create, alert: @user.errors
    end
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if user.update_attributes(user_params)
      if current_user.admin?
        redirect_to admin_user_path
      else
        redirect_to user_path
      end
    else
      render :edit, alert: @user.errors
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_index_path
  end

  private

  def user_params
    u_params = params.require(:user).permit(:first_name, :last_name, :email, :password)
    u_params[:password_confirmation] = params[:password]
    u_params
  end

end
