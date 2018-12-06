desc 'post all responses'
task post_results: :environment do
  # Check there is an open question
  # We don't need to do anything if not
  if Question.where(open: true).none?
    question = Question.where(open: true).first
    message = ':rocket: *The results are in!* :rocket:\n'
    question.responses.each do |answer|
      message += '@#{answer.user.ucode} said:\n>#{answer.response}'
    end
    puts message
  end

end