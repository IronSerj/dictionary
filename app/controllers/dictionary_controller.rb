class DictionaryController < ApplicationController
  def index
    @translations = Array.new
    @history = TranslationDecorator.decorate_collection(Translation.all)
  end

  def interpret
    @prms = params[:interpretation]
    articles = $api.lookup_arr(@prms)

    @translations = Translation.from_articles_arr(articles, @prms["lang"])
    @history = TranslationDecorator.decorate_collection(Translation.all)
    render 'index'
  end
end