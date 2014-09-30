class UserSessionsController < ApplicationController
  
  def new
    require_no_user
  end
  
  def create
    require_no_user
    if UserSession.new(params[:user_session]).save
      flash[:notice] = "Login successful!"
      redirect_back_or_default session_path
    else
      render :action => :new
    end
  end
  
  def destroy
    require_user
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default session_path
  end
end
