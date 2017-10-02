class SelectRoleController < ApplicationController
  def edit
  end

  def update
    if current_user.role != 'not-admited'
      current_user.update_attribute :role, params[:select_role][:role]

    end
    redirect_to root_path
  end
end
