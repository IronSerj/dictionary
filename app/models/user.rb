class User < ActiveRecord::Base
  include ActiveModel::Dirty
  define_attribute_methods
  has_many :translations, dependent: :destroy
  acts_as_authentic
  mount_uploader :avatar, AvatarUploader
  attr_protected :login, :avatar, :password, :password_confirmation, :email

  before_create do
    self.verification_token = SCrypt::Password.create(self.email)
  end

  after_save do
    init_verification if self.email_changed?
  end

  def verify_email
    self.update_attributes(:registration_confirmed => true)
  end

private  
  def init_verification
  	self.update_attributes(:registration_confirmed => false) if self.registration_confirmed
    UserMailer.verification_email(self).deliver
  end
end
