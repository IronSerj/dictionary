class UsersController < ApplicationController
  helper_method :requested_user

  def new
    require_no_user
    
  end
  
  def create
    require_no_user
    user = User.new(user_params)
    if user.save
      user.init_verification
      flash[:notice] = "Account registered!"
      render 'registration_finished'
    else
      render :action => :new
    end
  end

  def verification
    user = User.find_by(verification_token: params[:verification_token])
    user.update_attributes(:is_registration_confirmed => true)
    render 'verification_succeded'
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
    if requested_user.update_attributes(user_params)
      flash[:notice] = "Account updated!"
      redirect_to user_url
    else
      render :action => :edit
    end
  end

  private

  def requested_user
    return @requested_user if defined?(@requested_user)
    @requested_user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :email)
  end
end
