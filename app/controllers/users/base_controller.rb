class Users::BaseController < ApplicationController
  helper_method :requested_user

private
  def requested_user
    if params[:user_id] == Guest.id || params[:user_id] == nil
      current_user
    else
      requested_user_by_id(params[:user_id])
    end
  end
end