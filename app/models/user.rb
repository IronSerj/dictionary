class User < ActiveRecord::Base
  include ActiveModel::Dirty
  include UserBehavior
  has_many :translations, dependent: :destroy
  acts_as_authentic
  mount_uploader :avatar, AvatarUploader
  attr_accessible :login, :avatar, :as => :user_update
  attr_accessible :login, :avatar, :password, :password_confirmation, :email, :registration_confirmed, :last_used_lang, :avatar_cache, :guest

  before_create do
    self.verification_token = crypt(self.email)
  end

  after_save do
    init_verification if self.email_changed?
  end

  def verify_email
    self.update_attributes(:registration_confirmed => true)
  end

  def add_guest_history(uuid)
    if uuid
      g = Guest.new(:uuid => uuid) 
      g.translations.each do |t|
        t.set_user(self)
        t.save
      end
    end
  end

private
  def crypt(str)
    SCrypt::Password.create(str)
  end
 
  def init_verification
  	self.update_column(:registration_confirmed, false) if self.registration_confirmed
    UserMailer.verification_email(self).deliver
  end
end
