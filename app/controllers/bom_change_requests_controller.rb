# app/controllers/bom_change_requests_controller.rb
class BomChangeRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bom_change_request, only: %i[show edit update submit approve reject]

  # GET /bom_change_requests
  def index
    @q = BomChangeRequest.ransack(params[:q])
    @bom_change_requests = @q.result(distinct: true)
  end

  # GET /bom_change_requests/:id
  def show
    # 関連する差分リストを取得
    @details = @bom_change_request.bom_change_details
  end

  # GET /bom_change_requests/new
  def new
    @bom_change_request = BomChangeRequest.new
  end

  # POST /bom_change_requests
  def create
    @bom_change_request = BomChangeRequest.new(bom_change_request_params)
    @bom_change_request.status = 'draft'
    @bom_change_request.requested_by = current_user.to_s

    if @bom_change_request.save
      redirect_to @bom_change_request, notice: 'BOM Change Request was successfully created.'
    else
      render :new
    end
  end

  # GET /bom_change_requests/:id/edit
  def edit
    # 編集は draft 状態の場合のみ許可
    unless @bom_change_request.status == 'draft'
      redirect_to @bom_change_request, alert: 'Cannot edit a submitted or approved request.'
    end
  end

  # PATCH/PUT /bom_change_requests/:id
  def update
    if @bom_change_request.status != 'draft'
      redirect_to @bom_change_request, alert: 'Cannot update a submitted or approved request.'
      return
    end

    if @bom_change_request.update(bom_change_request_params)
      redirect_to @bom_change_request, notice: 'BOM Change Request was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH /bom_change_requests/:id/submit
  def submit
    if @bom_change_request.status == 'draft'
      @bom_change_request.update!(status: 'submitted', submitted_at: Time.current)
      redirect_to @bom_change_request, notice: 'BOM Change Request was submitted for review.'
    else
      redirect_to @bom_change_request, alert: 'Request is not in draft status.'
    end
  end

  # PATCH /bom_change_requests/:id/approve
  def approve
    if @bom_change_request.status == 'submitted'
      @bom_change_request.approve!(current_user.to_s)
      redirect_to @bom_change_request, notice: 'BOM Change Request was approved and new BOM Version created.'
    else
      redirect_to @bom_change_request, alert: 'Request is not in submitted status.'
    end
  end

  # PATCH /bom_change_requests/:id/reject
  def reject
    if @bom_change_request.status == 'submitted'
      @bom_change_request.reject!(current_user.to_s)
      redirect_to @bom_change_request, notice: 'BOM Change Request was rejected.'
    else
      redirect_to @bom_change_request, alert: 'Request is not in submitted status.'
    end
  end

  private

  def set_bom_change_request
    @bom_change_request = BomChangeRequest.find(params[:id])
  end

  def bom_change_request_params
    # 変更リクエスト作成時に必要なパラメータ（base_bom_version_id, reason, type_id, model_id など）
    params.require(:bom_change_request).permit(:type_id, :model_id, :base_bom_version_id, :reason)
  end
end
