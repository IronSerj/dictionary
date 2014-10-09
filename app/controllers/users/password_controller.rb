class Users::PasswordController < Users::BaseController

  def update
    require_user
    authorize! :update, requested_user
    if requested_user.valid_password?(params[:user][:current_password])
      if requested_user.update_attributes(user_params)
        flash[:notice] = "Account updated!"
        redirect_to user_url(requested_user)
      else
        redirect_to edit_user_url(requested_user)
      end
    else
      redirect_to edit_user_url(requested_user)
    end
  end

private

  def user_params
    params[:user].delete_if {|key, value| key == "current_password"}
  end
end
