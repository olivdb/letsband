class Instrument < ActiveRecord::Base
  attr_accessible :image_name, :name

  has_many :skills, dependent: :destroy
  has_many :users, through: :skills
  has_many :memberships
  
  validates :name, presence: true

  before_save { 
  	|instrument| 
  	if (!instrument.image_name || instrument.image_name.empty?)
  		instrument.image_name = (instrument.name.split(' ').join.underscore + '.png') 
  	end
  	}

    def image_path
      'instruments/' + image_name
    end


end
