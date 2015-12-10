class AdminController < ApplicationController
  before_action :require_admin_login

  def index
    @editors = sort_editors_by_params
  end

  private

  def sort_editors_by_params
    case params[:query]
    when "looking_for_work"
      User.where(admin: false, looking_for_work: true)
    when "not_looking_for_work"
      User.where(admin: false, looking_for_work: false)
    when "a_list"
      User.a_list.where(admin: false)
    when "b_list"
      User.b_list.where(admin: false)
    when "first_assignment"
      User.first_assignment.where(admin: false)
    when "not_yet_assigned"
      User.not_yet_assigned.where(admin: false)
    else
      User.editors
    end
  end
end
