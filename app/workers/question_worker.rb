# TODO: Move worker logic into service
require 'post_to_slack'
class QuestionWorker
  include Sidekiq::Worker
  def perform
    # First check there is no active question already
    if Question.open.none?
      # get a random unanswered question
      todays_question = Question.left_outer_joins(:responses).where(responses: {id: nil}).order("RANDOM()").first
      if today
        todays_question.open = true
        todays_question.date_asked = Date.today
        todays_question.save
        # puts today.question
        message = "Good morning! After your cup of :coffee:, here\'s today\'s question:\n>*#{todays_question.question}*"
        attachments = []
        # Get all active users and DM them the question
        all_users = User.where(active: true)
        all_users.each do |u|
          PostToSlack.post_slack_msg( u.channel, message, attachments )
        end
      else
        puts "All questions have been answered!"
      end

    else
      # Check sure this question hasn't expired
      # (In case cron failed to run for posting results)
      question = Question.where(open: true).first
      if question.date_asked.to_date == Date.today.advance(:days => -1)
        question.open = false
        question.save
        puts "Question expired."
      end
    end
  end
end