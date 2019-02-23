# TODO: Move worker logic into service
require 'post_to_slack'
class ReminderWorker
  include Sidekiq::Worker
  def perform

    # First check there is an active question
    return if Question.open.none?
    # get all active users and the active question
    all_users = User.hasnt_answered
    todays_question = Question.open.first
      
    return if all_users.none?
    all_users.each do |user|
      # Has this user answered?
        message = ":bow: Sorry to disturb your work…I haven’t received an answer from you yet. :pray: I'm a good listener if you have a few minutes. :ear:"
        attachments = []
        # Get all active users and DM them the question
        PostToSlack.post_slack_msg(user.ucode, message, attachments)
    end

  end
end