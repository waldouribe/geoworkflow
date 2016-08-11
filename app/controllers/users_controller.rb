class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    @user = User.find params[:id]
    @user.update(user_params)
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit(:id, :role)
  end
end