require "date"

desc "Reset each user's current_capacity at the beginning of the month"
task :reset_current_capacity do
  puts "Checking to see if it's the beginning of the month..."
  if Date.today.mday === 1
    puts "Queueing jobs for each editor to reset capacity..."
    User.editors.each { |u| UpdateUserCapacityJob.perform_later(u) }
  end
  puts "Done reseting capacity."
end
