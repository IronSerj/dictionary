class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :authentication_uid, :authentication_type
end
