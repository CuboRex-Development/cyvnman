class VersionsController < ApplicationController
  before_action :set_version, only: %i[ show edit update destroy ]
  before_action :set_part, only: %i[ new create ]

  def index
    @versions = Version.all
  end

  def show
  end

  def new
    @version = @part.versions.build
  end

  def edit
  end

  def create
    @version = @part.versions.build(version_params.except(:version_number_suffix))
    @version.version_number = "#{@part.part_number}-#{params[:version][:version_number_suffix]}"

    if @version.save
      redirect_to @part, notice: "Version was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @version.update(version_params)
      redirect_to @version, notice: "Version was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @version.destroy
    redirect_to versions_url, notice: "Version was successfully destroyed."
  end

  private

  def set_version
    @version = Version.find(params[:id])
  end

  def set_part
    @part = Part.find(params[:part_id])
  end

  def version_params
    params.require(:version).permit(:description, :part_id, :file_path, :scale, :sheet_size, :unit, :drawn_by, :checked_by, :approved_by, :drawn_date, :drawing_image, :version_number_suffix)
  end
end
