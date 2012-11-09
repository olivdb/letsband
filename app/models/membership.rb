class Membership < ActiveRecord::Base
  attr_accessible :band_id, :instrument_id, :user_id

  belongs_to :band
  belongs_to :user
  belongs_to :instrument
end
