class BlocksController < ApplicationController
  before_action :set_block, only: [:show, :edit, :update, :destroy, :add_part, :remove_part]
  before_action :set_types, only: %i[new edit create update]

  def index
    @q = Block.ransack(params[:q])
    @q.sorts = 'block_number asc' if @q.sorts.empty?
    @blocks = @q.result(distinct: true)
  end

  def new
    @block = Block.new
  end

  def edit
  end

  def create
    # 仮想属性として、番号生成用の値をセット
    @block = Block.new(block_params.except(:block_number_suffix, :type_id))
    @block.block_number_suffix = block_params[:block_number_suffix]
    @block.type_id_temp = block_params[:type_id]

    if type = Type.find_by(id: block_params[:type_id])
      @block.types << type unless @block.types.include?(type)
    end

    if @block.save
      respond_success(@block, notice: "Block was successfully created.")
    else
      respond_failure(@block, :new)
    end
  end

  def update
    @block.assign_attributes(block_params.except(:block_number_suffix, :type_id))
    @block.block_number_suffix = block_params[:block_number_suffix]
    @block.type_id_temp = block_params[:type_id]  # 更新時もセット
    if type = Type.find_by(id: block_params[:type_id])
      @block.types << type unless @block.types.include?(type)
    end
  
    if @block.save
      respond_success(@block, notice: "Block was successfully updated.")
    else
      respond_failure(@block, :edit)
    end
  end

  def destroy
    @block.destroy
    redirect_to blocks_url, notice: "Block was successfully destroyed."
  end

  def add_part
    part = Part.find(params[:part_id])
    if @block.add_part!(part)
      flash[:notice] = 'Part was successfully added to the block.'
    else
      flash[:alert] = @block.errors.full_messages.join(", ")
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
    params.require(:block).permit(:block_number_suffix, :block_name, :description, :type_id, type_ids: [])
  end
end
