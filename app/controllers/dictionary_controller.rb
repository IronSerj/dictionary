class DictionaryController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def index
    require_user
    @user = @current_user
    @translations = Array.new
    @history = TranslationDecorator.decorate_collection(Translation.all)
  end

  def interpret
    require_user
    @user = @current_user
    @prms = params[:interpretation]
    articles = $api.lookup_arr(@prms)

    @translations = Translation.from_articles_arr(articles, @prms["lang"])
    @history = TranslationDecorator.decorate_collection(Translation.all)
    render 'index'
  end
end