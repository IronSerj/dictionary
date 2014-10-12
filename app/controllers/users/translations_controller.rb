class Users::TranslationsController < Users::BaseController
  helper_method :translations, :translation, :lang

  def index
    require_guest_user
  end

  def new
    require_guest_user
    authorize! :create, translation
  end

  def create
    require_guest_user
    authorize! :create, translation
    unless requested_user.translations.get_translations(params[:translation])
      render :action => :new and return
    end
    render :action => :index
  end

  def show
    require_guest_user
  end

  def destroy
    require_guest_user
    authorize! :update, translation
    requested_user.translations.find(params[:id]).destroy
    redirect_to user_translations_path(requested_user)
  end

private

  def requested_user
    if params[:user_id]
      super
    else
      current_user
    end
  end

  def translations
    TranslationDecorator.decorate_collection(requested_user.translations)
  end

  def translation
    return @translation if defined?(@translation)
    if params[:id]
      @translation = TranslationDecorator.decorate(requested_user.translations.find(params[:id]))
    else
      @translation = Translation.new
      @translation.user = requested_user
      @translation
    end
  end
end
