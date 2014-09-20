class Translation < ActiveRecord::Base
  def to_string
    res = ""
    res << "Language: #{self.lang}\n" unless self.lang.size == 0
    res << "Text: #{self.text}\n" unless self.text.size == 0
    res << "Translations: #{self.translations}\n" unless self.translations.size == 0
    res << "Synonyms: #{self.synonyms}\n" unless self.synonyms.size == 0
    res << "Means: #{self.means}\n" unless self.means.size == 0
    res << "Examples: #{self.examples}\n" unless self.examples.size == 0
    res
  end

  def save
    super if Translation.find_by_text(self.text) == nil
  end
end