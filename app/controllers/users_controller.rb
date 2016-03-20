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
        swap_working_label(card, user)
        swap_interest_labels(card, user)
        break
      end
    end
  end

  def swap_working_label(card, user)
    if card.labels.any? { |label| label.id == available_label.id } && !user.looking_for_work
      card.remove_label(available_label)
      card.add_label(not_available_label)
    elsif card.labels.any? { |label| label.id == not_available_label.id } && user.looking_for_work
      card.remove_label(not_available_label)
      card.add_label(available_label)
    end
  end

  def swap_interest_labels(card, user)
    all_interest_ids = [
      "56ca0559152c3f92fd1ce619",
      "56ca0561152c3f92fd1ce61b",
      "56ca056f152c3f92fd1ce64e",
      "56ca0575152c3f92fd1ce667",
      "56ca0580152c3f92fd1ce687",
      "56ca0587152c3f92fd1ce6a0",
      "56ca0590152c3f92fd1ce6a8",
      "56ca0598152c3f92fd1ce6b5",
      "56ca059c152c3f92fd1ce6c3",
      "56ca05a5152c3f92fd1ce6e3",
      "56ca05aa152c3f92fd1ce6f8",
      "56ca05af152c3f92fd1ce6f9"
    ]
    existing_labels = card.labels.map { |label| label.id }
    user_interest_ids = user.get_interest_label
    card.labels.each do |label|
      card.remove_label(label) if !user_interest_ids.include?(label.id) && all_interest_ids.include?(label.id)
    end
    user_interest_ids.each do |id|
      card.add_label(Trello::Label.find(id)) if !existing_labels.include?(id)
    end
  end

  def check_user_permissions_for_page
    unless current_user_is_user_or_admin?
      redirect_to user_path(current_user),  alert: "You do not have permission to view that page."
      return
    end
  end

  def create_trello_card
    looking_for_work_label = @user.looking_for_work ? available_label.id : not_available_label.id
    category_label = @user.get_category_label
    interest_label = @user.get_interest_label.join(',')

    Trello::Card.create({
      name: @user.full_name,
      list_id: ENV['NOT_YET_ASSIGNED_LIST'],
      card_labels: [ looking_for_work_label, category_label, interest_label ].join(","),
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
      params[:category].each { |category_id| @user.interests.create(category_id: category_id.to_i) }
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
                                 :notes,
                                 :employed)
  end

end
