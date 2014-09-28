class Translation < ActiveRecord::Base

  def before_validation
    Translation.find_by_text(self.text) == nil
  end

  def self.from_articles_arr(arr, lang)
    translations = Array.new
    hash = Hash.new
    arr.each do |a|
      hash["lang"] = lang
      hash["text"] = a.text
      hash["translations"] = a.translations
      hash["synonyms"] = a.synonyms
      hash["means"] = a.means
      hash["examples"] = a.examples
      translations << TranslationDecorator.new(Translation.new(hash))
    end
    translations[0].save unless translations.size == 0
    translations
  end
end
