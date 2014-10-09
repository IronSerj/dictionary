class User < ActiveRecord::Base
  include ActiveModel::Dirty
  has_many :translations, dependent: :destroy do
    def get_translations(params)
      hash = Hash.new
      is_succeded = false
      proxy_association.owner.update_last_used_lang(params[:lang])
      $api.lookup_arr(params).each do |translation|
        hash["lang"] = params["lang"]
        hash["text"] = translation.text
        hash["translations"] = translation.translations
        hash["synonyms"] = translation.synonyms
        hash["means"] = translation.means
        hash["examples"] = translation.examples
        translation = TranslationDecorator.new(Translation.new(hash))
        translation.user = proxy_association.owner
        translation.save
        is_succeded = true
      end
      is_succeded
    end
  end
  acts_as_authentic
  mount_uploader :avatar, AvatarUploader
  attr_accessible :login, :avatar, :as => :user_update
  attr_accessible :login, :avatar, :password, :password_confirmation, :email, :registration_confirmed, :last_used_lang, :avatar_cache

  #validates :email, format: {with: /.+@.+\..+/, message: "is invalid."}


  before_create do
    self.verification_token = SCrypt::Password.create(self.email)
  end

  after_save do
    init_verification if self.email_changed?
  end

  def update_last_used_lang(lang)
    self.update_attributes(:last_used_lang => lang)
  end

  def verify_email
    self.update_attributes(:registration_confirmed => true)
  end

private  
  def init_verification
  	self.update_column(:registration_confirmed, false) if self.registration_confirmed
    UserMailer.verification_email(self).deliver
  end
end
