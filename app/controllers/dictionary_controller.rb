class DictionaryController < ApplicationController

  def index
    @history = Translation.all
  end

  def interpret
    @prms = params[:interpretation]
    articles = $api.lookup_arr(@prms)

    @translations = Translation.from_articles_arr(articles, @prms["lang"])
    @history = Translation.all
    render 'index'
  end

end