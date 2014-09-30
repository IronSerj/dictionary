class UserController < ApplicationController
  helper_method :requested_user

  def new
    require_no_user
    
  end

  def index
    redirect_to session_path
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
    user = User.find_by(verification_token: params[:token])
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
    raise StandardError unless requested_user.valid_password?(current_password[:current_password])
    if requested_user.update_attributes(user_params)
      flash[:notice] = "Account updated!"
      requested_user.init_verification if user_params[:email]
      redirect_to user_url
    else
      render :action => :edit
    end
  end

  private

  def requested_user
    requested_user_by_id(params[:id])
  end

  def current_password
    params.require(:user).permit(:current_password)
  end

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :email, :avatar).delete_if {|key, value| value == ""}
  end
end
