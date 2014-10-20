class User < ActiveRecord::Base
  include ActiveModel::Dirty
  include UserBehavior
  has_many :translations, dependent: :destroy
  has_many :authentications, dependent: :destroy
  acts_as_authentic
  mount_uploader :avatar, AvatarUploader
  attr_accessible :login, :avatar, :as => :user_update
  attr_accessible :login, :avatar, :password, :password_confirmation, :email, :registration_confirmed, :last_used_lang, :avatar_cache, :guest, :created_by_omniauth

  before_create do
    self.verification_token = crypt(self.email)
    if self.created_by_omniauth
      self.registration_confirmed = true
    end
  end

  after_save do
    if self.email_changed?() && self.login_changed?()
      if !self.created_by_omniauth
        init_verification
      end
    elsif self.email_changed?() && !self.login_changed?()
      init_verification
    end
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

  def self.find_or_create_user_from_auth(auth_hash)
    auth = Authentication.where(:authentication_type => auth_hash[:provider], :authentication_uid => auth_hash[:uid]).first
    if auth
      User.find(auth.user_id)
    else
      case auth_hash[:provider]
      when "github"
        User.authenticate_with_github(auth_hash)
      end
    end
  end

  def self.authenticate_with_github(auth_hash)
    user = User.where(:email => auth_hash[:info][:email]).first
    unless user
      prms = Hash.new
      prms[:login] = auth_hash[:info][:nickname]
      prms[:email] = auth_hash[:info][:email]
      prms[:password] = auth_hash[:uid]
      prms[:password_confirmation] = auth_hash[:uid]
      prms[:created_by_omniauth] = true
      user = User.new(prms)
      if user.save
        user.send_welcome_message(auth_hash[:uid])
      else
        return nil
      end
    end
    user.authentications.create(:authentication_uid => auth_hash[:uid], :authentication_type => auth_hash[:provider])
    user
  end

  def send_welcome_message(password)
    UserMailer.welcome_message(self, password).deliver
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
