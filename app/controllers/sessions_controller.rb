class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in(user)
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    sign_out(user)
    redirect_to root_url, notice: "Signed out!"
  end
end