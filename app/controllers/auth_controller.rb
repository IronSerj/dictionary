class AuthController < ApplicationController

  def callback
    require_no_user
    user = User.find_or_create_user_from_auth(request.env['omniauth.auth'])
    sign_user_in(user)
    redirect_to session_path
  end

end
