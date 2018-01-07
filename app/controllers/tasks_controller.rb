class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :begin, :finish]

  def index
    @tasks = Task.where("user => ? OR responsible_user", current_user, current_user).order('created_at DESC')
  end

  def show
  end

  def begin
    message = "##{@task.my_process.hashtag} #{@task.name} started now at #{@task.address}".first(140)
    Message.create(sender: current_user, message: message)
    @task.update_attributes actual_start: DateTime.now, responsible_user_id: current_user.id
    current_user.update_attributes(latitude: @task.latitude, longitude: @task.longitude)
    redirect_to @task.my_process
  end

  def finish
    Message.create(sender: current_user, message: "##{@task.my_process.hashtag} #{@task.name} ended")
    @task.update_attribute :actual_end, DateTime.now
    redirect_to @task.my_process
  end

  def new
    @task = Task.new(my_process_id: params[:my_process_id])
  end

  def edit
  end

  def create
    create_params = task_params
    create_params.delete(:waiting_for_task_ids)
    @task = Task.new(create_params)

    if @task.save
      @task.update(waiting_for_task_ids: task_params[:waiting_for_task_ids])
      redirect_to @task.my_process
    else
      redirect_to MyProcess.find(task_params[:my_process_id]), notice: "#{@task.errors.full_messages.first} -> #{create_params[:waiting_for_task_ids]}"
    end
  end

  def update
    if @task.update(task_params)
      redirect_to my_process_path(@task.my_process, anchor: "task-#{@task.id}")
    else
      redirect_to my_process_path(@task.my_process, anchor: "task-#{@task.id}")
    end
  end

  def destroy
    my_process = @task.my_process
    @task.destroy
    respond_to do |format|
      format.html{ redirect_to my_process }
      format.json { head :no_content }
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(
        :name,
        :my_process_id,
        :work_link,
        :work_description,
        :priority,
        :user_id,
        :address,
        :latitude,
        :longitude,
        :assigned_start,
        :assigned_end,
        :responsible_user_id,
        :description,
        :waiting_for_task_ids => [],
        :role_ids => []
      )
    end
end
