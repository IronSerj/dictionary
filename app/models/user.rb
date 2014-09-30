class User < ActiveRecord::Base
  has_many :translations, dependent: :destroy
  acts_as_authentic

  def initialize(params)
  	super(params)
  	self.verification_token = SCrypt::Password.create(self.email)
  end

  def init_verification
  	UserMailer.verification_email(self).deliver
  end

end
