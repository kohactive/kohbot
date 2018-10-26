class Question < ApplicationRecord
  has_many :responses, dependent: :destroy
end
