# TODO: Replace with https://github.com/slack-ruby/slack-ruby-client
class PostToSlack
  def self.post_slack_msg( channel, message, attachments )
    token = ENV["BOT_AUTH"]
    begin
      attachments = attachments.to_json
      if channel === "RESULTS"
        options = { query: { text: message, attachments: attachments } }
        url = ENV["RESULTS_CHANNEL"]
      else
        options = { query: { channel: channel, text: message, attachments: attachments }, headers: { 'Authorization' => "Bearer #{token}"} }
        url = 'https://slack.com/api/chat.postMessage'
      end
      response = HTTParty.post(url, options)
      puts response.to_json
    rescue => e
      puts e
    end
  end
end