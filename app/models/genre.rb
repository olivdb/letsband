class Genre < ActiveRecord::Base
  attr_accessible :name

  has_many :bands
  has_many :favorite_genres, dependent: :destroy
  has_many :users, through: :favorite_genres
end
