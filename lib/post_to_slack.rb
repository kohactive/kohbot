# TODO: Replace with https://github.com/slack-ruby/slack-ruby-client
class PostToSlack
  def self.post_slack_msg( channel, message, attachments )
    token = ENV["BOT_AUTH"]
    begin
      if channel === "RESULTS"
        Rails.logger.info("Posting to Results Channel")
        options = {
          :body => { :text => message, :attachments => attachments }.to_json,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
        }
        url = ENV["RESULTS_HOOK"]
      else
        attachments = attachments.to_json
        Rails.logger.info("Preparing to post a DM with KohBot")
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