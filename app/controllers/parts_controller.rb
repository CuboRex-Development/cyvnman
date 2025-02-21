class PartsController < ApplicationController
  before_action :set_part, only: %i[show edit update destroy add_related_part remove_related_part]
  before_action :set_block, only: %i[new create]

  def index
    @q = Part.ransack(params[:q])
    @q.sorts = 'part_number asc' if @q.sorts.empty?
    @parts = @q.result(distinct: true)
    if params[:search].present?
      @parts = Part.where('part_number LIKE ? OR part_name LIKE ? OR description LIKE ?', 
                          "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @parts = Part.all
    end
  end

  def show
    @related_parts = @part.related_parts
  end

  def new
    @part = Part.new
  end

  def edit
  end

  def create
    # 仮想属性を使って部品番号を自動生成させる
    @part = Part.new(part_params.except(:part_number_suffix))
    @part.part_number_suffix = part_params[:part_number_suffix]
    @part.primary_block_id = @block.id

    if @part.save
      @block.parts << @part unless @block.parts.include?(@part)
      respond_success(@part, notice: "Part was successfully created.")
    else
      respond_failure(@part, :new)
    end
  end

  def update
    if @part.update(part_params)
      respond_success(@part, notice: "Part was successfully updated.")
    else
      respond_failure(@part, :edit)
    end
  end

  def destroy
    @part.destroy
    redirect_to parts_url, notice: "Part was successfully destroyed."
  end

  def add_related_part
    related_part = Part.find(params[:related_part_id])
    unless @part.related_parts.include?(related_part)
      @part.related_parts << related_part
      related_part.related_parts << @part
    end
    respond_success(@part, notice: 'Related part was successfully added.')
  end

  def remove_related_part
    related_part = Part.find(params[:related_part_id])
    @part.related_parts.delete(related_part)
    related_part.related_parts.delete(@part)
    respond_success(@part, notice: 'Related part was successfully removed.')
  end

  private

  def set_part
    @part = Part.find(params[:id])
  end

  def set_block
    @block = Block.find(params[:block_id])
  end

  def part_params
    params.require(:part).permit(:part_number_suffix, :part_name, :description, :material, :nominal_size, :part_name_eg, :quantity, :image, related_part_ids: [])
  end
end
