module UserBehavior

  def get_translations(params)
    hash = Hash.new
    is_succeded = false
    self.update_last_used_lang(params[:lang])
    $api.lookup_arr(params).each do |translation|
      hash["lang"] = params["lang"]
      hash["text"] = translation.text
      hash["translations"] = translation.translations
      hash["synonyms"] = translation.synonyms
      hash["means"] = translation.means
      hash["examples"] = translation.examples
      translation = TranslationDecorator.new(Translation.new(hash))
      translation.set_user(self)
      translation.save
      is_succeded = true
    end
    is_succeded
  end

  def guest?
    self.is_a? Guest
  end

  def update_last_used_lang(lang)
    self.update_attributes(:last_used_lang => lang) unless self.guest?
  end
end