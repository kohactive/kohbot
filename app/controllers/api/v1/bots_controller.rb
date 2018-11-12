class Api::V1::BotsController < Api::V1::ApiController
  # Bot Controller
  ################
  skip_before_action :verify_authenticity_token

  def index
    render :json => {message: "empty."}, :status => :ok 
  end

  def create
    challenge = params[:challenge]
    token = params[:token]
    if challenge
      # Verify to Slack
      render :json => {challenge: challenge}, :status => :ok
    elsif token
      # Already verified => Proceed to Actions
      event = params[:event][:type]
      if event.include? "message"
        channel = params[:event][:channel]
        user = params[:event][:user]

        # Is this a status change?
        #### 'opt', 'yes', 'join', 'no', 'leave'
          # opt: inverse your current status (or create)
          # yes or join: change to opted in (or create)
            # message = "Thanks for joining! :tada:"
          # no or leave: change to opted out
            # message = "Take a break! :desert_island: Type `opt`, `yes` or `join` anytime to hop back in."

        # Is this a request to add a question?
          # message = "Good one! :eyes: Can't wait to share this one."

        # Is this a response to a question?
          # message = ":white_check_mark: Got it!"

        # None of the above: User Recognized
          # If opted out, ask if they want to rejoin
          # message = "You're back! :raised_hands: You're currently opted out. Want to join? Reply `opt`, `yes`, or `join`."
          # If opted in, give all options and (if applicable) current question
          # message = "Hey! :v: You're currently opted in. There's no active question right now.\nType `opt`, `no`, or `leave` to opt out.\nType `question:` followed by your question to add it to the database."
          # message = "Hey! :v: You're currently opted in.\nKohactivers want to know: *What would you do?*.\nType 'ans:` followed by your answer to submit your answer.\nType `opt`, `no`, or `leave` to opt out.\nType `question:` followed by your question to add it to the database."

        # None of the above: User Not Recognized
          message = "Hello! :wave: I don't see you in my system. :scream: Tell me `opt`, `yes`, or `join` to join our KohBot adventures."

        # Perform action
        post_slack_msg( channel, message )
      else
        render :json => {message: "handler for #{event} not found"}, :status => :not_implemented
      end
    else
      # Not a valid request from Slack
      render :json => {message: "Request not recognized."}, :status => :not_implemented
    end
  end


  ### POST message to slack
  def post_slack_msg( channel, message )
    token = ENV["BOT_AUTH"]
    begin
      options = { query: { channel: channel, text: message }, headers: { 'Authorization' => "Bearer #{token}"} }
      response = HTTParty.post('https://slack.com/api/chat.postMessage', options)
      render :json => {response: response }, :status => :ok
    rescue => e
      render :json => {message: "could not post message", error: e}, :status => :not_implemented
    end
  end
end