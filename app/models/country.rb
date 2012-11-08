class Country < ActiveRecord::Base
  attr_accessible :code, :name

  has_many :regions
  has_many :cities
  
end
