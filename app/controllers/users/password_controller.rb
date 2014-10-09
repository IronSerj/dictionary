class Users::PasswordController < Users::BaseController

  def update
    require_user
    authorize! :update, requested_user
    if requested_user.valid_password?(params[:user][:current_password])
      if requested_user.update_attributes(params[:user])
        flash[:notice] = "Account updated!"
        redirect_to user_url(requested_user)
      else
        render "users/edit"
      end
    else
      render "users/edit"
    end
  end
end
