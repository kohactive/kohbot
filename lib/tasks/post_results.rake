desc 'post all responses'
task post_results: :environment do
  # Check there is an open question
  # We don't need to do anything if not
  if Question.where(open: true).any?
    question = Question.where(open: true).first
    message = ":rocket: *The results are in!* :rocket:\n"
    question.responses.each do |answer|
      message += "@#{answer.user.ucode} said:\n>#{answer.answer}"
    end
    puts message
    question.open = false
    question.save
  end

end