class Users::BaseController < ApplicationController
  helper_method :requested_user

private
  def requested_user
    requested_user_by_id(params[:user_id])
  end
end