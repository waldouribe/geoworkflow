class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in(user)
    redirect_to select_role_path
  end

  def destroy
    sign_out(user)
    redirect_to select_role_path
  end
end