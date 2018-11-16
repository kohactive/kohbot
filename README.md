# KohBot

KohBot is fun for the whole Slack channel! :robot_face: :tada:

**KohBot:**
- Recieves fun culture questions from a user via DM
- Lets users opt in/out via DM
- Sends one question a day to users opted in via DM (in the morning)
- Users tell the bot their answer
- KohBot shares all the answers to the daily question in `#general` (or another channel)

## Getting Started
This repo is using `Rails version 5.1.4` and `Ruby version 2.4.4`.

Clone the repo and run `bundle install`.

## Setting Up With Slack

You will need to add a bot to your workspace. Your bot needs to subscribed to events. The route to hit will be `http://address-here.com/api/v1/bots`. You will need to add environment variables in the file `config/application.yml`. **DO NOT COMMIT THIS FILE.**

`BOT_AUTH: xoxb-1234567890-12324567890`.

Replace the string past the equals sign (`=`) with your bot's auth token provided by Slack.

## Local Development
To run locally, start the rails server:

`bin/rails s`

It's recommended you run a proxy to test with Slack, such as [ngrok](https://ngrok.com/).

`./ngrok http 3000`