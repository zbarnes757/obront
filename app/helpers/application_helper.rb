module ApplicationHelper

  def looking_for_work_class(user)
    if user.looking_for_work?
      "success"
    else
      "danger"
    end
  end

end
