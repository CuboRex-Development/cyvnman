class BlocksController < ApplicationController
  before_action :set_block, only: %i[ show edit update destroy ]
  before_action :set_types, only: %i[ new edit create update ]

  def index
    @q = Block.ransack(params[:q])
    @blocks = @q.result(distinct: true)
  end

  def new
    @block = Block.new
  end

  def edit
  end

  def create
    type = Type.find_by(id: block_params[:type_id])
    suffix = block_params[:block_number_suffix]
    @block = Block.new(block_params.except(:block_number_suffix, :type_id))
    if type
      @block.block_number = "#{type.type_number}-#{suffix}"
      @block.types << type unless @block.types.include?(type)
    end

    if @block.save
      redirect_to @block, notice: "Block was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    type = Type.find_by(id: block_params[:type_id])
    suffix = block_params[:block_number_suffix]
    if type
      @block.block_number = "#{type.type_number}-#{suffix}"
      @block.types << type unless @block.types.include?(type)
    end

    if @block.update(block_params.except(:block_number_suffix, :type_id))
      redirect_to @block, notice: "Block was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @block.destroy
    redirect_to blocks_url, notice: "Block was successfully destroyed."
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
