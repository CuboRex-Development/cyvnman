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
    # 仮想属性を使ってversion_numberを自動生成
    @version = @part.versions.build(version_params.except(:version_number_suffix))
    @version.version_number_suffix = version_params[:version_number_suffix]

    if @version.save
      # 例として、保存後は部品詳細ページへリダイレクト
      respond_success(@version, notice: "Version was successfully created.", redirect_url: @part)
    else
      respond_failure(@version, :new)
    end
  end

  def update
    if version_params[:version_number_suffix].present?
      @version.version_number_suffix = version_params[:version_number_suffix]
    end

    if @version.update(version_params.except(:version_number_suffix))
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
    params.require(:version).permit(:version_number_suffix, :description, :part_id, :file_path, :scale, :sheet_size, :unit, :drawn_by, :checked_by, :approved_by, :drawn_date, :drawing_image)
  end
end
