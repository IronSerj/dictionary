class User < ActiveRecord::Base
  has_many :translations, dependent: :destroy
  acts_as_authentic
  mount_uploader :avatar, AvatarUploader

  def initialize(params)
    super(params)
    self.verification_token = SCrypt::Password.create(self.email)
  end

  def init_verification
  	self.update_attributes(:is_registration_confirmed => false)
    UserMailer.verification_email(self).deliver
  end
end
