class MyProcessesController < ApplicationController
  before_action :set_my_process, only: [:create_tasks, :new_tasks, :show, :edit, :update, :destroy, :success]

  def index
    @my_processes = MyProcess.visibles_for(current_user).order('created_at DESC')
    if @my_processes.any?
      redirect_to @my_processes.first
    else
      render :empty
    end
  end

  def success
  end

  def show
    @my_processes = MyProcess.visibles_for(current_user).order('created_at DESC')
    if current_user.role == 'worker'
      render :show_worker
    elsif current_user.role == 'admin'
      render :show_admin
    else
      render text: 'An admin must approve you'
    end
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
      redirect_to @my_process
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
      redirect_to @my_process
    else
      render :edit
    end
  end

  def destroy
    @my_process.destroy
    respond_to do |format|
      format.html { redirect_to my_processes_url }
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
