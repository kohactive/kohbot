desc 'post all responses'
task post_results: :environment do
  require 'post_to_slack'
  # Check there is an open question
  # We don't need to do anything if not
  if Question.where(open: true).any?
    question = Question.where(open: true).first
    message = ":rocket: *The results are in!* :rocket:\n"
    if question.responses.none?
      message =+ "...Or not? *Nobody submitted their answers!* :flushed: How embarassing."
    else
      question.responses.each do |answer|
        message += "@#{answer.user.ucode} said:\n>#{answer.answer}"
      end
      channel = 'DDV3FC2BX'
      PostToSlack.post_slack_msg( channel, message )
    end
    question.open = false
    question.save
  end

end