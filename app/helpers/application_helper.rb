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

  def states_options
    Array[ ["", nil],
           ["AK", "Alaska"],
           ["AL", "Alabama"],
           ["AR", "Arkansas"],
           ["AS", "American Samoa"],
           ["AZ", "Arizona"],
           ["CA", "California"],
           ["CO", "Colorado"],
           ["CT", "Connecticut"],
           ["DC", "District of Columbia"],
           ["DE", "Delaware"],
           ["FL", "Florida"],
           ["GA", "Georgia"],
           ["GU", "Guam"],
           ["HI", "Hawaii"],
           ["IA", "Iowa"],
           ["ID", "Idaho"],
           ["IL", "Illinois"],
           ["IN", "Indiana"],
           ["KS", "Kansas"],
           ["KY", "Kentucky"],
           ["LA", "Louisiana"],
           ["MA", "Massachusetts"],
           ["MD", "Maryland"],
           ["ME", "Maine"],
           ["MI", "Michigan"],
           ["MN", "Minnesota"],
           ["MO", "Missouri"],
           ["MS", "Mississippi"],
           ["MT", "Montana"],
           ["NC", "North Carolina"],
           ["ND", "North Dakota"],
           ["NE", "Nebraska"],
           ["NH", "New Hampshire"],
           ["NJ", "New Jersey"],
           ["NM", "New Mexico"],
           ["NV", "Nevada"],
           ["NY", "New York"],
           ["OH", "Ohio"],
           ["OK", "Oklahoma"],
           ["OR", "Oregon"],
           ["PA", "Pennsylvania"],
           ["PR", "Puerto Rico"],
           ["RI", "Rhode Island"],
           ["SC", "South Carolina"],
           ["SD", "South Dakota"],
           ["TN", "Tennessee"],
           ["TX", "Texas"],
           ["UT", "Utah"],
           ["VA", "Virginia"],
           ["VI", "Virgin Islands"],
           ["VT", "Vermont"],
           ["WA", "Washington"],
           ["WI", "Wisconsin"],
           ["WV", "West Virginia"],
           ["WY", "Wyoming"] ]
  end

end
