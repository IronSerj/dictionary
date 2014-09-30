class User < ActiveRecord::Base
  has_many :translations, dependent: :destroy
  acts_as_authentic

end
