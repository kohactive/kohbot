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
        # Received a DM to KohBot => Get Channel & User of conversation
        channel = params[:event][:channel]
        user = params[:event][:user]
        @user = User.where(ucode: user).first
        # Check first word for a command
        command = params[:event][:text].partition(" ").first

        # First, check this isn't our bot talking...
        if params[:event][:subtype].eql? "bot_message"
          # Do nothing -- that last message was us!
        # Is this a status change?
        elsif ['opt','yes','join','no','leave'].any? { |word| command.include?(word) }
          if !@user
            @user = User.new(ucode: user, active: false)
          end
          # opt: inverse your current status (or create)
          if command.include?("opt")
            message = opt_route( @user )

          # yes or join: change to opted in (or create)
          elsif ['yes','join'].any? { |word| command.include?(word) }
            message = join_route( @user )

          # no or leave: change to opted out
          else
            message = leave_route( @user )
          end

        elsif command.include?("question:")
          # Is this a request to add a question?
          message = "Good one! :eyes: Can't wait to share this one."

        elsif command.include?("ans:")
          # Is this a response to a question?
          message = ":white_check_mark: Got it!"

        else
          # None of the above -- do we know who this is?
          # Look for user
          if @user
            # true === opted in
            if @user.active
              # If opted in, give all options and (if applicable) current question
              message = "Hey! :v: You're currently opted in. There's no active question right now.\nType `opt`, `no`, or `leave` to opt out.\nType `question:` followed by your question to add it to the database."
              # message = "Hey! :v: You're currently opted in.\nKohactivers want to know: *What would you do?*.\nType 'ans:` followed by your answer to submit your answer.\nType `opt`, `no`, or `leave` to opt out.\nType `question:` followed by your question to add it to the database."
            else
              # false === opted out
              # If opted out, ask if they want to rejoin
              message = "You're back! :raised_hands: You're currently opted out. Want to join? Reply `opt`, `yes`, or `join`."
            end
          else
            # User Not Found
            message = "Hello! :wave: New bot, who 'dis? :eyes: Tell me `opt`, `yes`, or `join` to join our KohBot adventures."
          end
        end

        # Perform action
        if message
          post_slack_msg( channel, message )
        end
      else
        render :json => {message: "handler for #{event} not found"}, :status => :not_implemented
      end
    else

      # Not a valid request from Slack
      render :json => {message: "Request not recognized."}, :status => :not_implemented
    end
  end


  ### TOGGLE user status
  def opt_route( @user )
    if @user.active === true
      @user.active = false
      if @user.save
        return "Come back soon! :wave:"
      else
        return "Sorry, something went wrong. :robot_face: Please try again."
      end
    else
      @user.active = true
      if @user.save
        return "You're in! :tada:"
      else
        return "Sorry, something went wrong. :robot_face: Please try again."
      end
    end
  end

  ### JOIN / set user to active
  def join_route( @user )
    @user.active = true
    if @user.save
      return "Thanks for joining! :tada:"
    else
      return "Sorry, something went wrong. :robot_face: Please try again."
    end
  end

  ### LEAVE / set user to inactive
  def leave_route( @user )
    @user.active = false
    if @user.save
      return "Take a break! :desert_island: Type `opt`, `yes` or `join` anytime to hop back in."
    else
      return "Sorry, something went wrong. :robot_face: Please try again."
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