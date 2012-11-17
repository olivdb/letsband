class Membership < ActiveRecord::Base
  attr_accessible :band_id, :instrument_id, :user_id, :role

  belongs_to :band
  belongs_to :user
  belongs_to :instrument

  validates :user_id, presence: true, :uniqueness => {:scope => :band_id, :message => 'already exists.', :unless => Proc.new { |user| user.role == "open" }}
  validates :band_id, presence: true
  validates :instrument_id, presence: true
  validates :role, presence: true, :inclusion => {:in => ["open", "invited", "member", "manager", "owner"]}, :unless => Proc.new { |user| user.user_id.nil? }

end
