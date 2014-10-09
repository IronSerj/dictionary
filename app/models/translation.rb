class Translation < ActiveRecord::Base
  attr_accessible :lang, :text, :translations, :synonyms, :means, :examples
  belongs_to :user
  
end
