class UserSessionsController < ApplicationController
  helper_method :user_session
  def new
    require_no_user
  end
  
  def create
    require_no_user
    guest_user = current_user if current_user
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if guest_user
        current_user.get_guest_history(guest_user)
        guest_user.destroy
      end
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

private
  def user_session
    return @user_session if defined?(@user_session)
    @user_session = UserSession.new
  end
end
