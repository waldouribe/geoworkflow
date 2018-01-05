class SelectRoleController < ApplicationController
  include Geokit::Geocoders

  def edit
  end

  def update
    if current_user.role != 'not-admited'
      ip = request.remote_ip
      current_user.ip = ip
      current_user.role = params[:select_role][:role]
      location = Geokit::Geocoders::GoogleGeocoder.geocode(ip)

      if location and defined?(location.lat)
        current_user.latitude = location.lat
        current_user.longitude = location.lng
      end
      current_user.save
    end
    render text: request.location.to_yaml;return
    redirect_to root_path
  end
end
