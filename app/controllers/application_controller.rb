class ApplicationController < ActionController::Base
  helper_method :current_user
  
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user && !current_user.guest?
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_back_or_default session_path
        return false
      end
    end

    def require_guest_user
      unless current_user
        @current_user = User.new.guest
        UserSession.new(@current_user).save
        redirect_to new_user_translation_path(@current_user)
      end
    end

    def require_no_user
      if current_user && !current_user.guest?
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to user_path(current_user)
      end
    end
    
    def store_location
      session[:return_to] = request.url
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def requested_user_by_id(id)
      return @requested_user if defined?(@requested_user)
      @requested_user = User.find(id)
    end
end
