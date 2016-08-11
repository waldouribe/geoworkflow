class MyProcessesController < ApplicationController
  before_action :set_my_process, only: [:show, :edit, :update, :destroy, :success]

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

    respond_to do |format|
      if @my_process.save
        format.html { redirect_to success_my_process_path(@my_process) }
        format.json { render :show, status: :created, location: @my_process }
      else
        format.html { render :new }
        format.json { render json: @my_process.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @my_process.update(my_process_params)
        format.html { redirect_to @my_process, notice: 'My process was successfully updated.' }
        format.json { render :show, status: :ok, location: @my_process }
      else
        format.html { render :edit }
        format.json { render json: @my_process.errors, status: :unprocessable_entity }
      end
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
      params.require(:my_process).permit(:process_type_id, :user_id, :address, :latitude, :longitude, :starts_at)
    end
end
