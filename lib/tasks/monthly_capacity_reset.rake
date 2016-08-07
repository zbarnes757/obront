desc "Reset each user's current_capacity at the beginning of the month"
task :reset_current_capacity do
  User.editors.each { |u| UpdateUserCapacityJob.perform_later(u) }
end
