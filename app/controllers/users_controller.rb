class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update, :show]
  before_action :require_admin_login, only: [:new, :create, :destroy]
  before_action :get_user, only: [:edit, :show, :update, :destroy]
  before_action :check_user_permissions_for_page, only: [:edit, :update, :show]

  def create
    @user = User.new(user_params)
    if @user.save
      add_interests
      create_trello_card if !@user.admin
      redirect_to admin_index_path, notice: "User has been successfully created."
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
  end

  def update
    if @user.update_attributes(user_params)
      update_interests
      change_trello_label(@user)
      add_trello_comment(@user)
      if current_user.admin?
        redirect_to admin_index_path, notice: "User has been successfully updated."
      else
        redirect_to user_path(@user), notice: "Your settings have been successfully updated."
      end
    else
      flash[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_index_path
  end

  def insta_change_status
    current_user.update_attributes(looking_for_work: !current_user.looking_for_work)
    change_trello_label(current_user)
    redirect_to user_path(current_user)
  end

  private

  def add_interests
    if params[:category]
      params[:category].each do |category_id|
        @user.interests.create(category_id: category_id.to_i)
      end
    end
  end

  def add_trello_comment(user)
    freelancer_board.cards.each do |card|
      if card.name == user.full_name
        card.add_comment(user.build_comment)
        break
      end
    end
  end

  def change_trello_label(user)
    freelancer_board.cards.each do |card|
      if card.name == user.full_name
        if card.labels.any? { |label| label.id == available_label.id } && !user.looking_for_work
          card.remove_label(available_label)
          card.add_label(not_available_label)
          break
        elsif card.labels.any? { |label| label.id == not_available_label.id } && user.looking_for_work
          card.remove_label(not_available_label)
          card.add_label(available_label)
          break
        end
      end
    end
  end

  def check_user_permissions_for_page
    unless current_user_is_user_or_admin?
      redirect_to user_path(current_user),  alert: "You do not have permission to view that page."
      return
    end
  end

  def create_trello_card
    label_id = @user.looking_for_work ? available_label.id : not_available_label.id

    Trello::Card.create({
      name: @user.full_name,
      list_id: ENV['NOT_YET_ASSIGNED_LIST'],
      card_labels: label_id,
      desc: @user.build_description
      })
  end

  def current_user_is_user_or_admin?
    @user == current_user || current_user.admin?
  end

  def get_user
    @user = User.find(params[:id])
  end

  def update_interests
    if params[:category]
      @user.interests.delete_all
      params[:category].each do |category_id|
        @user.interests.create(category_id: category_id.to_i)
      end
    end
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :looking_for_work,
                                 :admin,
                                 :classification,
                                 :phone,
                                 :street,
                                 :city,
                                 :state,
                                 :zipcode,
                                 :payment_address,
                                 :payment_method,
                                 :calendly_link,
                                 :notes)
  end

end
