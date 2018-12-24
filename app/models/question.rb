class Question < ActiveRecord::Base
  has_many :responses, dependent: :destroy
  belongs_to :user
  # open : boolean
  # date_asked : date
  scope :open, -> { where(open: true) }
end