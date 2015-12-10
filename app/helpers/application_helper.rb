module ApplicationHelper

  def looking_for_work_class(user)
    if user.looking_for_work?
      "success"
    else
      "danger"
    end
  end

  def admin_search_options
    [
      ["All Editors", :all],
      ["Only Looking for work", :looking_for_work],
      ["Not Looking for work", :not_looking_for_work],
      ["A-list Editors", :a_list],
      ["B-list Editors", :b_list],
      ["First Assigment", :first_assignment ],
      ["Not Yet Assigned", :not_yet_assigned]
    ]
  end

end
