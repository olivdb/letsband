class Region < ActiveRecord::Base
  attr_accessible :code, :country_id, :name

  has_many :cities
  belongs_to :country
end
