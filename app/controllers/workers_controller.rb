class WorkersController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :begin, :finish]

  def index
    @workers = User.where(role: 'worker').order("name ASC")
    workers_with_location = @workers.where("latitude IS NOT NULL")
    @locations = workers_with_location.map{|worker| {latitude: worker.latitude, longitude: worker.longitude, title: worker.name}}
  end
end
