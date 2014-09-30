class TranslationController < ApplicationController
  helper_method :translations, :translation, :requested_user

  def index
    require_user
  end

  def new
    require_user
    authorize! :update, requested_user
  end

  def create
    require_user
    authorize! :update, requested_user
    i = Translation.from_articles_arr($api.lookup_arr(params[:interpretation]), params[:interpretation][:lang], requested_user)
    if i[0]
      redirect_to user_translation_path(requested_user, i[0])
    else
      redirect_to user_translation_index_path
    end
  end

  def edit
    require_user
    authorize! :update, requested_user
  end

  def show
    require_user
  end

  def update
    require_user
    authorize! :update, requested_user
  end

  def destroy
    require_user
    authorize! :update, requested_user
    requested_user.translations.find(params[:id]).destroy
    redirect_to user_translation_index_path(requested_user)
  end

  private

  def translations
    TranslationDecorator.decorate_collection(requested_user.translations)
  end

  def translation
    return @translation if defined?(@translation)
    @translation = TranslationDecorator.decorate(Translation.find(params[:id]))
  end

  def requested_user
    requested_user_by_id(params[:user_id])
  end
end
