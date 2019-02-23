require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ReminderWorker, type: :worker do
  subject { ReminderWorker.new.perform() }

  # The unanaswered user is the one who wrote the question
  # Generates 4 active users, 3 in :with_answers, 1 as the question's author
  # Generate an inactive question to be sure doesn't check that one
  let!(:old_question) { FactoryBot.create(:question,) }
  let!(:question) { FactoryBot.create(:question, :with_answers, :is_open) }
  let!(:inactive_users) { FactoryBot.create_list(:user, 2, :inactive) }

  context 'reminds users to answer' do
    it 'has one question with 2 answers' do
      subject
      expect(Question.all.count).to eq(1)
      expect(Question.first.responses.count).to eq(3)
    end

    it 'only reminds active users who havent answered' do
      expect(PostToSlack).to receive(:post_slack_msg).once
      subject
    end
  end

end