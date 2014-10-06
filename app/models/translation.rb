class Translation < ActiveRecord::Base
  include  ActiveModel::MassAssignmentSecurity
  belongs_to :user
  attr_protected :lang, :text
  attr_accessible :lang, :text, :translations, :synonyms, :means, :examples, :as => :translation

  def self.get_translations(params, user)
    translations = Array.new
    hash = Hash.new
    $api.lookup_arr(params).each do |translation|
      hash["lang"] = params["lang"]
      hash["text"] = translation.text
      hash["translations"] = translation.translations
      hash["synonyms"] = translation.synonyms
      hash["means"] = translation.means
      hash["examples"] = translation.examples
      translations << TranslationDecorator.new(Translation.new(hash, :as => :translation))
      translations[translations.size - 1].user = user
      translations[translations.size - 1].save
    end
    translations
  end
end
