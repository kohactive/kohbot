class Question < ActiveRecord::Base
  has_many :responses, dependent: :destroy
  belongs_to :user
  # open : boolean
  # date_asked : date
  scope :open, -> { where(open: true) }

  def mark_as_open!
    update(open: true)
  end

  def mark_as_closed!
    update(open: false, date_asked: Date.today)
  end
end