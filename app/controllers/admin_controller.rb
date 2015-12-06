class AdminController < ApplicationController
  before_action :require_admin_login

  def index
    if params[:looking_for_work] == "true"
      @editors = User.where(admin: false, looking_for_work: true)
    elsif params[:looking_for_work] == "false"
      @editors = User.where(admin: false, looking_for_work: false)
    else
      @editors = User.editors
    end
  end

end
