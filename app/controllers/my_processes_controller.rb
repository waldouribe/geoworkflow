class MyProcessesController < ApplicationController
  before_action :set_my_process, only: [:show, :edit, :update, :destroy]

  # GET /my_processes
  # GET /my_processes.json
  def index
    @my_processes = MyProcess.where(user: current_user)
  end

  # GET /my_processes/1
  # GET /my_processes/1.json
  def show
    @my_processes = MyProcess.where(user: current_user)
  end

  # GET /my_processes/new
  def new
    @my_process = MyProcess.new
  end

  # GET /my_processes/1/edit
  def edit
  end

  # POST /my_processes
  # POST /my_processes.json
  def create
    @my_process = MyProcess.new(my_process_params)
    @my_process.user = @my_process.process_type.user

    respond_to do |format|
      if @my_process.save
        format.html { redirect_to @my_process, notice: 'My process was successfully created.' }
        format.json { render :show, status: :created, location: @my_process }
      else
        format.html { render :new }
        format.json { render json: @my_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /my_processes/1
  # PATCH/PUT /my_processes/1.json
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

  # DELETE /my_processes/1
  # DELETE /my_processes/1.json
  def destroy
    @my_process.destroy
    respond_to do |format|
      format.html { redirect_to my_processes_url, notice: 'My process was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_my_process
      @my_process = MyProcess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def my_process_params
      params.require(:my_process).permit(:process_type_id, :user_id, :address, :latitude, :longitude, :starts_at)
    end
end
