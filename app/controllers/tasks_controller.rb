class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :begin, :finish]

  def index
    @tasks = Task.where("user => ? OR resposile_user", current_user, current_user).order('created_at DESC')
  end

  def show
  end

  def begin
    Message.create(sender: current_user, message: "##{@task.my_process.hashtag} #{@task.name} started now at #{@task.address}")
    @task.update_attribute :actual_start, DateTime.now
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
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task.my_process
    else
      render :new
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
        :user_id, 
        :address, 
        :latitude, 
        :longitude, 
        :assigned_start, 
        :assigned_end, 
        :responsible_user_id, 
        :description,
        :waiting_for_task_ids => [],
        :role_ids => [])
      )
    end
end
