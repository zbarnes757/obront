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
      ["Not Yet Assigned Editor", :not_yet_assigned],
      ["First Assingment Editor", :first_assignment],
      ["Probationary Editor", :b_list],
      ["Veteran Editor", :a_list],
      ["All Star Editor", :all_star],
      ["All Star Outliners", :all_star_outliner],
      ["Veteran Outliners", :a_list_outliner],
      ["Trial Period Outliner", :trial_period],
      ["Proofreader", :proof_reader],
      ["Cover Designer", :cover_designer]
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
           ["WY", "Wyoming"],
           ["Outside US", "Outside US"] ]
  end

end
