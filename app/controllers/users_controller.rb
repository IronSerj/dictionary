class UsersController < ApplicationController
  helper_method :requested_user, :user

  def new
    require_no_user
  end

  def index
    redirect_to session_path
  end
  
  def create
    require_no_user
    @user = User.new(params[:user])
    if @user.save
      UserSession.new(@user).save
      move_guest_history
      flash[:notice] = "Account registered!"
    else
      render :action => :new
    end
  end

  def verify
    user = User.find_by(verification_token: params[:token])
    user.verify_email
    sign_user_in(user)
  end
  
  def show
    require_user
  end

  def edit
    require_user
    authorize! :update, requested_user
  end
  
  def update
    require_user
    authorize! :update, requested_user
    if requested_user.update_attributes(params[:user], :as => :user_update)
      flash[:notice] = "Account updated!"
      redirect_to user_url(requested_user)
    else
      render :action => :edit
    end
  end

private

  def requested_user
    requested_user_by_id(params[:id])
  end

  def user
    return @user if defined?(@user)
    @user = User.new
  end
end
