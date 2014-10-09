class User < ActiveRecord::Base
  include ActiveModel::Dirty
  define_attribute_methods
  has_many :translations, dependent: :destroy do
    def get_translations(params, user_id)
      hash = Hash.new
      is_succeded = false
      $api.lookup_arr(params).each do |translation|
        hash["lang"] = params["lang"]
        hash["text"] = translation.text
        hash["translations"] = translation.translations
        hash["synonyms"] = translation.synonyms
        hash["means"] = translation.means
        hash["examples"] = translation.examples
        translation = TranslationDecorator.new(Translation.new(hash))
        translation.user_id = user_id #how to get owner here????????????????????????????????????
        translation.save
        is_succeded = true
      end
      is_succeded
    end
  end
  acts_as_authentic
  mount_uploader :avatar, AvatarUploader
  attr_accessible :login, :avatar, :as => :user_update
  attr_accessible :login, :avatar, :password, :password_confirmation, :email, :registration_confirmed


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
