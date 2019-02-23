class User < ApplicationRecord
  has_many :responses

  scope :hasnt_answered, -> {
    where(active: true).left_outer_joins(:responses => :question).where(responses: {user_id: nil, question: {open: true}})
  }
end
