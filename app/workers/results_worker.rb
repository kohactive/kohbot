# TODO: Move worker logic into service
require 'post_to_slack'
class ResultsWorker
  include Sidekiq::Worker
  def perform
    # Check there is an open question
    # We don't need to do anything if not
    if Question.open.any?
      question = Question.open.first
      message = ":rocket: *The results are in!* :rocket:\n"
      attachments = []
      # Did we get responses?
      if question.responses.none?
        attachments.push({
              fallback: "...Or not? *Nobody submitted their answers!* :flushed: How embarassing.",
              color: "danger",
              author_name: "<@kohbot>",
              text: "...Or not? *Nobody submitted their answers!* :flushed: How embarassing."
        })
      else
        # Yes -- publish responses
        question.responses.each do |answer|
          attachments.push({
            fallback: "#{answer.answer}",
            color: "good",
            author_name: "<@#{answer.user.ucode}> said:",
            text: "#{answer.answer}"
          })
        end
        channel = "RESULTS"
        PostToSlack.post_slack_msg( channel, message, attachments )
      end
      # Set question to inactive
      question.mark_as_closed!
    end # end check if question
  end
end