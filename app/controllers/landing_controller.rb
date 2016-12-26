class LandingController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landing'

  def index
    if user_signed_in?
      redirect_to new_my_process_path
    else
      render 'index'
    end
  end
end
