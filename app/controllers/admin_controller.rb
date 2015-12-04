class AdminController < ApplicationController
  before_action :require_admin_login

  def index
    @users = User.all
  end

end
