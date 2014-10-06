class Users::PasswordController < Users::BaseController
  include  ActiveModel::MassAssignmentSecurity
  attr_accessible :password, :password_confirmation, :email, :as => :user

  def update
    require_user
    authorize! :update, requested_user
    if requested_user.valid_password?(params[:user][:current_password])
      if requested_user.update_attributes(user_params, :as => :user)
        flash[:notice] = "Account updated!"
        redirect_to user_url
      else
        redirect_to edit_user_url
      end
    else
      redirect_to edit_user_path(requested_user)
    end
  end

private
  def requested_user
    requested_user_by_id(params[:id])
  end

  def user_params
    params[:user].delete_if {|key, value| key == "current_password"}
  end
end
