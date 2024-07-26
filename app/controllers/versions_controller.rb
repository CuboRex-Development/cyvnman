class VersionsController < ApplicationController
  before_action :set_version, only: %i[ show edit update destroy ]

  # GET /versions or /versions.json
  def index
    @versions = Version.all
  end

  # GET /versions/1 or /versions/1.json
  def show
  end

  # GET /versions/new
  def new
    @version = Version.new
  end

  # GET /versions/1/edit
  def edit
  end

  # POST /versions or /versions.json
  def create
    @version = Version.new(version_params)

    respond_to do |format|
      if @version.save
        format.html { redirect_to version_url(@version), notice: "Version was successfully created." }
        format.json { render :show, status: :created, location: @version }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /versions/1 or /versions/1.json
  def update
    respond_to do |format|
      if @version.update(version_params)
        format.html { redirect_to version_url(@version), notice: "Version was successfully updated." }
        format.json { render :show, status: :ok, location: @version }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /versions/1 or /versions/1.json
  def destroy
    @version.destroy!

    respond_to do |format|
      format.html { redirect_to versions_url, notice: "Version was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_version
      @version = Version.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def version_params
      params.require(:version).permit(:version_number, :description, :part_id)
    end
end
