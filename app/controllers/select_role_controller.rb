class SelectRoleController < ApplicationController
  def edit
  end

  def update
    if current_user.role != 'not-admited'
      ip = request.ip
      current_user.ip = ip
      current_user.role = params[:select_role][:role]
      current_user.save
    end
    redirect_to root_path
  end
end
