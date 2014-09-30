class UsersController < ApplicationController
  helper_method :requested_user

  def new
    require_no_user
    
  end
  
  def create
    require_no_user
    if User.new(user_params).save
      flash[:notice] = "Account registered!"
      UserMailer.verification_email(User.find_by(login: user_params[:login])).deliver
      render 'registration_finished'
    else
      render :action => :new
    end
  end

  def verification
    user = User.find_by(verification_token: params[:verification_token])
    user.update_attributes(:is_registration_confirmed => true)
    redirect_to session_path
  end
  
  def show
    require_user
  end

  def edit
    require_user
  end
  
  def update
    require_user
    if current_user.update_attributes(user_params)
      flash[:notice] = "Account updated!"
      redirect_to user_url
    else
      render :action => :edit
    end
  end

  private

  def requested_user
    if current_user.id == params[:id]
      current_user
    else
      return @requested_user if defined?(@requested_user)
      @requested_user = User.find(params[:id])
    end
  end

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :email)
  end
end
