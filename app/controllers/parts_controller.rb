# frozen_string_literal: true

class PartsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_part, only: %i[show edit update destroy add_related_part remove_related_part]
  before_action :set_block, only: %i[new create]

  def index
    @q = Part.ransack(params[:q])
    @q.sorts = 'part_number asc' if @q.sorts.empty?
  
    # ▼ 追加: block_parts を JOIN して一発集計
    @parts =
      @q.result(distinct: true)
        .left_joins(:block_parts)
        .select('parts.*, COALESCE(SUM(block_parts.quantity), 0) AS total_quantity')
        .group('parts.id')
        .page(params[:page]).per(10)
  end

  def show
    # ─── ① 本体 ───────────────────────────────────────
    @part = Part
              .includes(image_attachment: :blob)
              .find(params[:id])
  
    @version = Version.new      # New-Version 用の空レコード
  
    # ─── ② すでに結び付いている部品 ──────────────────
    @related_parts = @part.related_parts
                           .includes(image_attachment: :blob)
                           .order(:part_number)
  
    # ─── ③ Add-Relation 候補  ★ここを Kaminari ページング★ ─
    excluded_ids    = @related_parts.pluck(:id) << @part.id
    @candidate_parts = Part.where.not(id: excluded_ids)
                           .includes(image_attachment: :blob)
                           .order(:part_number)
                           .page(params[:cand_page])  # ← Kaminari
                           .per(10)   
    block_ids   = @part.blocks.pluck(:id)
    @qty_map    = BlockPart.where(block_id: block_ids)
                         .group(:part_id)
                         .sum(:quantity)
  end
  

  def new
    @part = Part.new
  end

  def edit; end

  def create
    @part = Part.new(part_params)
    @part.primary_block_id = @block.id

    if @part.save
      quantity = params[:part][:quantity].to_i
      quantity = 1 if quantity.zero?
      @block.add_part!(@part, quantity)
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

  def add_related_part
    related_part = Part.find(params[:related_part_id])
    qty          = params[:quantity].to_i
  
    begin
      @part.add_related_part!(related_part, qty)
      respond_success(@part, notice: "Related part を数量 #{qty} で追加しました。")
    rescue ArgumentError => e
      flash[:alert] = e.message
      redirect_to @part
    end
  end

  def remove_related_part
    related_part = Part.find(params[:related_part_id])
    qty          = params[:quantity].to_i

    @part.remove_related_part!(related_part, qty)   # ← Model サービスを呼ぶ
    respond_success(@part, notice: "Removed #{qty} pcs of #{related_part.part_number}.")
  rescue ArgumentError => e
    flash[:alert] = e.message
    redirect_to @part
  end

  private

  def set_part
    @part = Part.find(params[:id])
  end

  def set_block
    @block = Block.find(params[:block_id])
  end

  def part_params
    # 採番用のパラメータ（part_number_suffix）は不要になったため、許可しない
    params.require(:part).permit(:part_name, :description, :material, :nominal_size, :part_name_eg, :quantity,
                                 :standard_price, :image, related_part_ids: [])
  end
end
