# frozen_string_literal: true

class BlocksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_block, only: %i[show edit update destroy add_part remove_part]
  before_action :set_types, only: %i[new edit create update]

  def index
    @q = Block.ransack(params[:q])
    @q.sorts = 'block_number asc' if @q.sorts.empty?
    @blocks = @q.result(distinct: true)
  end

  def new
    @block = Block.new
  end

  def edit; end

  def show
      @block = Block.find(params[:id])
    
      # ── Related Parts ─────────────────────────────────────────────
      raw = @block.block_parts.includes(part: { image_attachment: :blob })
      sorted = raw.sort_by { |bp| bp.part.part_number.split('-').map(&:to_i) }
      @block_parts = Kaminari.paginate_array(sorted)
                             .page(params[:page]).per(10)
    
      # ★ ここを忘れていた → Add-Part 候補をページング付きで用意
      excluded_ids     = @block.parts.pluck(:id)
      @candidate_parts = Part.where.not(id: excluded_ids)
                             .includes(image_attachment: :blob)
                             .order(:part_number)
                             .page(params[:cand_page])  # ← これだけで OK
                             .per(10)
    
      @part = Part.new  
  end
  

  def create
    # ブロックの基本情報は block_params から取得し、採番用のタイプIDはフォームから params[:block][:type_id] を利用
    @block = Block.new(block_params)
    @block.primary_type_id = params[:block][:type_id]

    if ((type = Type.find_by(id: params[:block][:type_id]))) && !@block.types.include?(type)
      @block.types << type
    end

    if @block.save
      respond_success(@block, notice: 'Block was successfully created.')
    else
      respond_failure(@block, :new)
    end
  end

  def update
    @block.assign_attributes(block_params)
    @block.primary_type_id = params[:block][:type_id]

    if ((type = Type.find_by(id: params[:block][:type_id]))) && !@block.types.include?(type)
      @block.types << type
    end

    if @block.save
      respond_success(@block, notice: 'Block was successfully updated.')
    else
      respond_failure(@block, :edit)
    end
  end

  def destroy
    @block.destroy
    redirect_to blocks_url, notice: 'Block was successfully destroyed.'
  end

  def add_part
    part = Part.find(params[:part_id])
    quantity = params[:quantity].to_i.presence || 1
    if @block.add_part!(part, quantity)
      flash[:notice] = 'Part was successfully added to the block.'
    else
      flash[:alert] = @block.errors.full_messages.join(', ')
    end
    redirect_to @block
  end

  def remove_part
    part = Part.find(params[:part_id])
    @block.remove_part!(part)
    flash[:notice] = 'Part was successfully removed from the block.'
    redirect_to @block
  end

  private

  def set_block
    @block = Block.find(params[:id])
  end

  def set_types
    @types = Type.all
  end

  def block_params
    # type_id はフォームから渡されるがDBには存在しないため、許可せずに仮想属性で処理する
    params.require(:block).permit(:block_name, :description, type_ids: [])
  end
end
