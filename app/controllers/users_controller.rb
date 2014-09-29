class UsersController < ApplicationController
  
  def new
    require_no_user
  end
  
  def create
    require_no_user
    if User.new(user_params).save
      flash[:notice] = "Account registered!"
      redirect_back_or_default user_url
    else
      render :action => :new
    end
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

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end
end
