require 'post_to_slack'
class Api::V1::BotsController < Api::V1::ApiController
  # Bot Controller
  ################
  skip_before_action :verify_authenticity_token

  def index
    today = Question.left_outer_joins(:responses).where(responses: {id: nil}).order("RANDOM()").first
    render :json => { question: today }, :status => :ok 
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
            @user = User.new(ucode: user, active: false, channel: channel)
          end
          # opt: inverse your current status (or create)
          if command.include?("opt")
            message = opt( @user )

          # yes or join: change to opted in (or create)
          elsif ['yes','join'].any? { |word| command.include?(word) }
            message = join( @user )

          # no or leave: change to opted out
          else
            message = leave( @user )
          end

        elsif command.include?("question:")
          # Is this a request to add a question?
          message = save_question( params[:event][:text], @user )

        elsif command.include?("ans:")
          # Is this a response to a question?
          message = save_answer( params[:event][:text], @user)

        else
          # None of the above -- do we know who this is?
          # Look for user
          if @user
            # true === opted in
            if @user.active
              if Question.open.none?
                # If opted in, give all options and (if applicable) current question
                message = "Hey! :v: You're currently opted in. There's no active question right now.\nType `opt`, `no`, or `leave` to opt out.\nType `question:` followed by your question to add it to the database."
              else
                question = Question.open.first
                message = "Hey! :v: You're currently opted in.\nKohactivators want to know: *#{question.question}*.\nType `ans:` followed by your answer to submit your answer.\nType `opt`, `no`, or `leave` to opt out.\nType `question:` followed by your question to add it to the database."
              end
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
          PostToSlack.post_slack_msg( channel, message, [] )
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
  def opt( user )
    if user.active?
      user.active = false
      if user.save
        return "Come back soon! :wave:"
      else
        return "Sorry, something went wrong. :robot_face: Please try again."
      end
    else
      user.active = true
      if user.save
        return "You're in! :tada:"
      else
        return "Sorry, something went wrong. :robot_face: Please try again."
      end
    end
  end

  ### JOIN / set user to active
  def join( user )
    user.active = true
    if user.save
      return "Thanks for joining! :tada:"
    else
      return "Sorry, something went wrong. :robot_face: Please try again."
    end
  end

  ### LEAVE / set user to inactive
  def leave( user )
    user.active = false
    if user.save
      return "Take a break! :desert_island: Type `opt`, `yes` or `join` anytime to hop back in."
    else
      return "Sorry, something went wrong. :robot_face: Please try again."
    end
  end

  ### ADD QUESTION
  def save_question( text, user )
    query = text.gsub("question:", "")
    query = query.strip
    if Question.where('lower(question) =?', query.downcase).any?
      return "Can you believe......... Someone already asked that!"
    else
      question = Question.new(question: query, user: user)
      if question.save
        return "Good one! :eyes: Can't wait to share this one."
      else
        return "My bad. Didn't quiet catch that. :blush: Try again?"
      end
    end
  end

  ## Save Answer
  def save_answer( text, user )
    if Question.where(open: true).any?
      question = Question.open.first
      if question.responses.left_outer_joins(:user).where(user: user).none?
        reply = text.gsub("ans:", "")
        reply = reply.strip
        answer = question.responses.new(answer: reply, user: user)
        if answer.save
          return ":white_check_mark: Got it!"
        else
          return "I'm a bad bot and couldn't save your answer!! :sob:"
        end
      else
        return ":scream: You already answered this question! No takesy-backsies! :upside_down_face:"
      end
    else
      return "There's no active question right now, ya goof! :wink:"
    end
  end
end