class DictionaryController < ApplicationController
  helper_method :history_of_interpretations, :interpretations, :langs

  def index
    require_user
  end

  private
    def history_of_interpretations
      TranslationDecorator.decorate_collection(current_user.translations)
    end

    def interpretations
      if params[:interpretation]
        Translation.from_articles_arr($api.lookup_arr(params[:interpretation]), params[:interpretation][:lang], current_user)
      else
        Array.new
      end
    end

    def langs
      $langs
    end
end