class WaitingsController < ApplicationController
  before_action :set_waiting, only: [:show, :edit, :update, :destroy]

  def index
    @waitings = Waiting.all
  end

  def show
  end

  def new
    @waiting = Waiting.new(task_id: params[:task_id])
    @task = @waiting.task
    
    excluded_tasks_ids = [@task.id]
    excluded_tasks_ids += @task.waiting_for_tasks.pluck(:id).uniq
    
    @waitable_tasks = Task.where(my_process: @task.my_process).where.not(id: excluded_tasks_ids)
  end

  def edit
  end

  def create
    @waiting = Waiting.new waiting_params

    if @waiting.save
      redirect_to @waiting.task.my_process
    else
      render :new
    end    
  end

  def update
    respond_to do |format|
      if @waiting.update(waiting_params)
        format.html { redirect_to @waiting, notice: 'Waiting was successfully updated.' }
        format.json { render :show, status: :ok, location: @waiting }
      else
        format.html { render :edit }
        format.json { render json: @waiting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @waiting.destroy
    respond_to do |format|
      format.html { redirect_to waitings_url, notice: 'Waiting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_waiting
      @waiting = Waiting.find(params[:id])
    end

    def waiting_params
      params.require(:waiting).permit(:task_id, :waiting_id)
    end
end
