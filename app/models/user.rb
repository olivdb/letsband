# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  surname    :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :firstname, :surname, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :firstname, presence: true, length: { maximum: 20 }
  validates :surname, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  				    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

end
