class PartsController < ApplicationController
  before_action :set_part, only: %i[ show edit update destroy ]
  before_action :set_block, only: %i[ new create ]

  def index
    @q = Part.ransack(params[:q])
    @parts = @q.result(distinct: true)
  end

  def show
  end

  def new
    @part = Part.new
  end

  def edit
  end

  def create
    block_number = @block.block_number
    suffix = part_params[:part_number_suffix]
    @part = Part.new(part_params.except(:part_number_suffix))
    @part.part_number = "#{block_number}-#{suffix}"

    if @part.save
      @block.parts << @part
      redirect_to @part, notice: "Part was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @part.update(part_params)
      redirect_to @part, notice: "Part was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @part.destroy
    redirect_to parts_url, notice: "Part was successfully destroyed."
  end

  private

  def set_part
    @part = Part.find(params[:id])
  end

  def set_block
    @block = Block.find(params[:block_id])
  end

  def part_params
    params.require(:part).permit(:part_number_suffix, :part_name, :description)
  end
end
