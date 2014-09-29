class Translation < ActiveRecord::Base

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
      translations[translations.size - 1].save
    end
    translations
  end
end
