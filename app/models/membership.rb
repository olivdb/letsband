class Membership < ActiveRecord::Base
  attr_accessible :band_id, :instrument_id, :user_id, :role

  belongs_to :band
  belongs_to :user
  belongs_to :instrument

  validates :user_id, presence: true, :uniqueness => {:scope => :band_id, :message => 'already exists.'}
  validates :band_id, presence: true
  validates :instrument_id, presence: true
  validates :role, presence: true

end
