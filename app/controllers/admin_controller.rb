class AdminController < ApplicationController
  before_action :require_admin_login

  def index
    @editors = sort_editors_by_params
  end

  private

  def booleaned_work_statuses
    if params[:looking_for_work]
      return params[:looking_for_work].map { |status| status == "true" ? true : false }
    else
      return [ true, false ]
    end
  end

  def sort_editors_by_params
    User.where(admin: false, looking_for_work: booleaned_work_statuses, classification: symbolized_classifications)
  end

  def symbolized_classifications
    if params[:classification]
      return params[:classification].map { |classification| User.classifications[classification] }
    else
      return [ 0, 1, 2, 3]
    end
  end
end
