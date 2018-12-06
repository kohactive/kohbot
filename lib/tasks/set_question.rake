desc 'set question for the day'
task set_todays_question: :environment do
  require 'post_to_slack'

  # First check there is no active question already
  if Question.where(open: true).none?
    # get a random unanswered question
    today = Question.left_outer_joins(:responses).where(responses: {id: nil}).order("RANDOM()").first
    if today
      today.open = true
      today.date_asked = Date.today
      today.save
      # puts today.question
      channel = 'DDV3FC2BX'
      message = 'Good morning! After your cup of :coffee:, here\'s today\'s question:\n>*#{today.question}*'
      attachments = []
      PostToSlack.post_slack_msg( channel, message, attachments )
    else
      puts "All questions have been answered!"
    end

  else
    # Check sure this question hasn't expired
    question = Question.where(open: true).first
    if question.date_asked.to_date == Date.today.advance(:days => -1)
      question.open = false
      question.save
      puts "Question expired."
    end
  end

end