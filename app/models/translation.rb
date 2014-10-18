class Translation < ActiveRecord::Base
  attr_accessible :lang, :text, :translations, :synonyms, :means, :examples
  belongs_to :user

  def set_user(user)
    if user.guest?
      self.guest_uuid = user.uuid
    else
      self.user_id = user.id
    end
  end
  
end
