class PostToSlack
  def self.post_slack_msg( channel, message )
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