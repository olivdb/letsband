class Skill < ActiveRecord::Base
  attr_accessible :instrument_id, :interest, :expertise

  belongs_to :user
  belongs_to :instrument

  validates :user_id, presence: true
  validates :instrument_id, presence: true

  validates :interest, inclusion: { in: 1..5 }
  validates :expertise, inclusion: { in: 1..5 }
end
