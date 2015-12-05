class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update, :show]
  before_action :require_admin_login, only: [:new, :create, :destroy]
  before_action :get_user, only: [:edit, :show, :update, :destroy]
  before_action :check_user_perissions_for_page, only: [:edit, :update, :show]

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_index_path
    else
      render :create, alert: @user.errors
    end
  end

  def new
    @user = User.new
  end

  def edit
    check_user_perissions_for_page
  end

  def show
    check_user_perissions_for_page
  end

  def update
    check_user_perissions_for_page
    if @user.update_attributes(user_params)
      if current_user.admin?
        redirect_to admin_index_path
      else
        redirect_to user_path
      end
    else
      render :edit, alert: @user.errors
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_index_path
  end

  private

  def check_user_perissions_for_page
    unless current_user_is_user_or_admin?
      redirect_to user_path(current_user),  alert: "You do not have permission to view that page."
      return
    end
  end

  def current_user_is_user_or_admin?
    @user == current_user || current_user.admin?
  end

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    u_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :looking_for_work, :admin)
    u_params[:password_confirmation] = params[:password]
    u_params
  end

end
