desc 'set question for the day'
task set_todays_question: :environment do
  # get a random unanswered question
  today = Question.left_outer_joins(:responses).where(responses: {id: nil}).order("RANDOM()").first
  puts today.question
end