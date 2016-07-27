class ProcessTypesController < ApplicationController
  before_action :set_process_type, only: [:show, :edit, :update, :destroy]

  def index
    @process_types = ProcessType.all
  end

  def show
  end

  def new
    @process_type = ProcessType.new
  end

  def edit
  end

  def create
    @process_type = ProcessType.new(process_type_params)
    @process_type.user = current_user

    respond_to do |format|
      if @process_type.save
        format.html { redirect_to @process_type, notice: 'Process type was successfully created.' }
        format.json { render :show, status: :created, location: @process_type }
      else
        format.html { render :new }
        format.json { render json: @process_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @process_type.update(process_type_params)
        format.html { redirect_to @process_type, notice: 'Process type was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_type }
      else
        format.html { render :edit }
        format.json { render json: @process_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @process_type.destroy
    respond_to do |format|
      format.html { redirect_to process_types_url, notice: 'Process type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_process_type
      @process_type = ProcessType.find(params[:id])
    end

    def process_type_params
      params.require(:process_type).permit(:user_id, :name, :hashtag, :description)
    end
end
