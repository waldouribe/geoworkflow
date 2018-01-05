class SelectRoleController < ApplicationController
  include Geokit::Geocoders

  def edit
  end

  def update
    if current_user.role != 'not-admited'

      current_user.ip = request.ip
      current_user.role = params[:select_role][:role]
      location = IpGeocoder.geocode(request.ip)
      puts(location)
      render text: location;return
      current_user.save
    end
    render text: request.location.to_yaml;return
    redirect_to root_path
  end
end
