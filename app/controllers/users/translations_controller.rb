class Users::TranslationsController < Users::BaseController
  helper_method :translations, :translation, :new_translation

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
    i = Translation.get_translations(params[:translation], requested_user)
    if i[0]
      redirect_to user_translation_path(requested_user, i[0])
    else
      @new_translation = Translation.new(params[:translation])
      render :action => :new
    end
  end

  def edit
    require_user
    authorize! :update, translation
  end

  def show
    require_user
  end

  def update
    require_user
    authorize! :update, translation
  end

  def destroy
    require_user
    authorize! :update, translation
    requested_user.translations.find(params[:id]).destroy
    redirect_to user_translations_path(requested_user)
  end

private

  def translations
    TranslationDecorator.decorate_collection(requested_user.translations)
  end

  def translation
    return @translation if defined?(@translation)
    @translation = TranslationDecorator.decorate(requested_user.translations.find(params[:id]))
  end

  def new_translation
    return @new_translation if defined?(@new_translation)
    @new_translation = Translation.new
  end
end
