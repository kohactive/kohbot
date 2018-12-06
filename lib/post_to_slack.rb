class PostToSlack
  def self.post_slack_msg( channel, message, attachments )
    token = ENV["BOT_AUTH"]
    begin
      attachments = attachments.to_json
      options = { query: { channel: channel, text: message, attachments: attachments }, headers: { 'Authorization' => "Bearer #{token}"} }
      response = HTTParty.post('https://slack.com/api/chat.postMessage', options)
      puts response.to_json
    rescue => e
      puts e
    end
  end
end