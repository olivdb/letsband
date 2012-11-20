class Membership < ActiveRecord::Base
  attr_accessible :band_id, :instrument_id, :user_id, :role

  belongs_to :band
  belongs_to :user
  belongs_to :instrument

  validates :user_id, presence: true, :uniqueness => { :scope => :band_id, :message => 'already invited.', :if => Proc.new { |membership| membership.role == "invited" } }
  validates :user_id, :uniqueness => { :scope => [:band_id, :instrument_id], :message => 'cannot play the same instrument more than once', :unless => Proc.new { |membership| membership.instrument.name == "Unknown" || membership.role == "open" || membership.role == "invited" } }
  validates :band_id, presence: true
  validates :instrument_id, presence: true
  validates :role, presence: true, :inclusion => {:in => ["open", "invited", "member", "manager", "owner"]}, :unless => Proc.new { |membership| membership.user_id.nil? }

end
