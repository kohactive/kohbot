class Question < ApplicationRecord
  has_many :responses, dependent: :destroy
  belongs_to :user
  # open : boolean
  # date_asked : date
end
