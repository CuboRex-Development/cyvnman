class VersionsController < ApplicationController
  before_action :set_version, only: %i[show edit update destroy download]
  before_action :set_part, only: %i[new create edit update]

  def index
    @q = Version.ransack(params[:q])
    @q.sorts = 'version_number asc' if @q.sorts.empty?
    @versions = @q.result(distinct: true)
  end

  def show
  end

  def new
    @version = @part.versions.build
  end

  def edit
    @part = @version.part
  end

  def create
    @version = @part.versions.build(version_params)
    @version.drawn_by = current_user
    if @version.save
      respond_success(@version, notice: "Version was successfully created.", redirect_url: @part)
    else
      respond_failure(@version, :new)
    end
  end

  def update
    if @version.update(version_params)
      respond_success(@version, notice: "Version was successfully updated.")
    else
      respond_failure(@version, :edit)
    end
  end

  def destroy
    @version.destroy
    redirect_to versions_url, notice: "Version was successfully destroyed."
  end

  def download
    if @version.drawing_image.attached?
      send_data @version.drawing_image.download,
                filename: @version.drawing_image.filename.to_s,
                content_type: @version.drawing_image.content_type
    else
      redirect_to @version, alert: 'No file attached to this version.'
    end
  end

  def check
    @version = Version.find(params[:id])
    # チェック操作：チェック済みでない場合のみ current_user をセット
    if @version.checked_by.blank?
      @version.update(checked_by: current_user)
      flash[:notice] = "Version has been checked."
    else
      flash[:alert] = "Already checked."
    end
    redirect_to version_path(@version)
  end
  
  def approve
    @version = Version.find(params[:id])
    # 承認操作：承認済みでない場合のみ current_user をセット
    if @version.approved_by.blank? && @version.checked_by.present?
      @version.update(approved_by: current_user)
      flash[:notice] = "Version has been approved."
    else
      flash[:alert] = "Cannot approve. Either already approved or not checked."
    end
    redirect_to version_path(@version)
  end  

  private

  def set_version
    @version = Version.find(params[:id])
  end

  def set_part
    @part = Part.find(params[:part_id])
  rescue ActiveRecord::RecordNotFound
    @part = @version&.part
  end

  def version_params
    # version_number_suffix は削除
    params.require(:version).permit(:description, :part_id, :file_path, :scale, :sheet_size, :unit, :drawn_by, :checked_by, :approved_by, :drawn_date, :drawing_image)
  end
end
