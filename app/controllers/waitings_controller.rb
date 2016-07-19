class WaitingsController < ApplicationController
  before_action :set_waiting, only: [:show, :edit, :update, :destroy]

  # GET /waitings
  # GET /waitings.json
  def index
    @waitings = Waiting.all
  end

  # GET /waitings/1
  # GET /waitings/1.json
  def show
  end

  # GET /waitings/new
  def new
    @waiting = Waiting.new
  end

  # GET /waitings/1/edit
  def edit
  end

  # POST /waitings
  # POST /waitings.json
  def create
    @waiting = Waiting.new(waiting_params)

    respond_to do |format|
      if @waiting.save
        format.html { redirect_to @waiting, notice: 'Waiting was successfully created.' }
        format.json { render :show, status: :created, location: @waiting }
      else
        format.html { render :new }
        format.json { render json: @waiting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waitings/1
  # PATCH/PUT /waitings/1.json
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

  # DELETE /waitings/1
  # DELETE /waitings/1.json
  def destroy
    @waiting.destroy
    respond_to do |format|
      format.html { redirect_to waitings_url, notice: 'Waiting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waiting
      @waiting = Waiting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def waiting_params
      params.require(:waiting).permit(:task_id, :waiting_id)
    end
end
