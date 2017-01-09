class MyProcessesController < ApplicationController
  before_action :set_my_process, only: [:create_tasks, :new_tasks, :show, :edit, :update, :destroy, :success]

  def index
    @my_processes = MyProcess.visibles_for(current_user).order('created_at DESC')
    if @my_processes.any? and current_user.role?(:admin)
      redirect_to @my_processes.first
    else
      render 'index'
    end
  end

  def success
  end

  def show
    @my_processes = MyProcess.visibles_for(current_user).order('created_at DESC')
  end

  def new
    @my_process = MyProcess.new
  end

  def edit
  end

  def create
    @my_process = MyProcess.new(my_process_params)
    @my_process.user = current_user

    if @my_process.save
      redirect_to new_tasks_my_process_path(@my_process)
      #redirect_to success_my_process_path(@my_process)
    else
      render :new
    end
  end

  def new_tasks
  end

  def create_tasks
    @my_process.update(my_process_params)
    redirect_to my_process_path(@my_process)
  end

  def update
    if @my_process.update(my_process_params)
      redirect_to @my_process, notice: 'My process was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @my_process.destroy
    respond_to do |format|
      format.html { redirect_to my_processes_url, notice: 'My process was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_my_process
      @my_process = MyProcess.find(params[:id])
    end

    def my_process_params
      params.require(:my_process).permit(:name, :hashtag, tasks_attributes: [:id, :name, :address, :assigned_start, :assigned_end])
    end
end
