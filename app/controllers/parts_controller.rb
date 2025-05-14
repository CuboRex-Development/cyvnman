# frozen_string_literal: true

class PartsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  # ※ add_related_part / remove_related_part だけを指定
  before_action :set_part, only: %i[show edit update destroy add_related_part remove_related_part]
  before_action :set_block, only: %i[new create]

  # --------------------------------------------------
  # GET /parts
  # --------------------------------------------------
  def index
    @q = Part.ransack(params[:q])
    @q.sorts = 'part_number asc' if @q.sorts.empty?

    # block_parts を JOIN して累計数量を 1 クエリで取得
    @parts = @q.result(distinct: true)
               .left_joins(:block_parts)
               .select('parts.*, COALESCE(SUM(block_parts.quantity), 0) AS total_quantity')
               .group('parts.id')
               .page(params[:page]).per(10)
  end

  # --------------------------------------------------
  # GET /parts/:id
  # --------------------------------------------------
  def show
    @version = Version.new

    # 既存の関連パーツ
    @related_parts = @part.related_parts
                          .includes(image_attachment: :blob)
                          .order(:part_number)

    # Add‑Relation 候補（ページング）
    excluded_ids   = @related_parts.pluck(:id) << @part.id
    @candidate_parts = Part.where.not(id: excluded_ids)
                            .includes(image_attachment: :blob)
                            .order(:part_number)
                            .page(params[:cand_page]).per(10)

    # PartLink 由来の数量ハッシュ { related_part_id => qty }
    @qty_map = PartLink
                 .where(part_id: @part.id, part_association_id: @related_parts.ids)
                 .pluck(:part_association_id, :quantity)
                 .to_h
  end

  # --------------------------------------------------
  # GET /parts/new
  # --------------------------------------------------
  def new
    @part = Part.new
  end

  def edit; end

  # --------------------------------------------------
  # POST /blocks/:block_id/parts
  # --------------------------------------------------
  def create
    @part = Part.new(part_params)
    @part.primary_block_id = @block.id

    if @part.save
      qty = params[:part][:quantity].to_i.nonzero? || 1
      @block.add_part!(@part, qty)
      respond_success(@block, notice: 'Part was successfully created and added to block.')
    else
      respond_failure(@part, :new)
    end
  end

  def update
    if @part.update(part_params)
      respond_success(@part, notice: 'Part was successfully updated.')
    else
      respond_failure(@part, :edit)
    end
  end

  def destroy
    @part.destroy
    redirect_to parts_url, notice: 'Part was successfully destroyed.'
  end

  # --------------------------------------------------
  # POST /parts/:id/add_related_part
  # --------------------------------------------------
  def add_related_part
    related = Part.find(params[:related_part_id])
    qty     = params[:quantity].to_i

    @part.add_related_part!(related, qty)
    respond_success(@part, notice: "Added #{qty} pcs of #{related.part_number}.")
  rescue ArgumentError => e
    flash[:alert] = e.message
    redirect_to @part
  end

  # --------------------------------------------------
  # DELETE /parts/:id/remove_related_part
  # --------------------------------------------------
  def remove_related_part
    related = Part.find(params[:related_part_id])
    qty     = params[:quantity].to_i

    @part.remove_related_part!(related, qty)
    respond_success(@part, notice: "Removed #{qty} pcs of #{related.part_number}.")
  rescue ArgumentError => e
    flash[:alert] = e.message
    redirect_to @part
  end

  # --------------------------------------------------
  # private helpers
  # --------------------------------------------------
  private

  def set_part
    @part = Part.find(params[:id])
  end

  def set_block
    @block = Block.find(params[:block_id])
  end

  def part_params
    params.require(:part).permit(:part_name, :description, :material, :nominal_size,
                                 :part_name_eg, :quantity, :standard_price, :image,
                                 related_part_ids: [])
  end
end
