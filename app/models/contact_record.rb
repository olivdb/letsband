class ContactRecord < ActiveRecord::Base
  attr_accessible :contact_id, :owner_id
  belongs_to :owner, class_name: "User"
  belongs_to :contact, class_name: "User"
end
