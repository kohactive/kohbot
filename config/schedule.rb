# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# We do mulitple times so if the cron fails to run
# there is a chance for it to still run for the day
every :weekday, at: ['9:00 am', '9:30am', '10:00 am'] do 
  rake "Task.set_todays_question"
end

every :weekday, at: ['12:00pm', '12:30pm', '01:00 pm'] do 
  rake "Task.post_results"
end