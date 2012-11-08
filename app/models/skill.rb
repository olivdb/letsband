class Skill < ActiveRecord::Base
  attr_accessible :instrument_id, :priority, :expertise, :experience, :education

  belongs_to :user
  belongs_to :instrument

  validates :user_id, presence: true
  validates :instrument_id, presence: true

  validates :priority, presence: true
  validates :expertise, presence: true, inclusion: { in: 1..3 }
  validates :experience, presence: true
  validates :education, presence: true, inclusion: { in: 0..4 }
end
