class FavoriteGenre < ActiveRecord::Base
  attr_accessible :genre_id, :looking_for_band, :user_id

  belongs_to :user
  belongs_to :genre

  validates :user_id, presence: true
  validates :genre_id, presence: true, :uniqueness => {:scope => :user_id, :message => 'already exists.'}

end
