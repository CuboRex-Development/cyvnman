class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy, :add_block, :remove_block]

  def index
    @q = Model.ransack(params[:q])
    @models = @q.result(distinct: true)
  end

  def show
  end

  def new
    @model = Model.new
  end

  def edit
  end

  def create
    @model = Model.new(model_params)

    if @model.save
      redirect_to @model, notice: "Model was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @model.update(model_params)
      redirect_to @model, notice: "Model was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @model.destroy
    redirect_to models_url, notice: "Model was successfully destroyed."
  end

  def add_block
    block = Block.find(params[:block_id])
    unless @model.blocks.include?(block)
      @model.blocks << block
      flash[:notice] = 'Block was successfully added to the model.'
    else
      flash[:alert] = 'This block is already in the model.'
    end
    redirect_to @model
  end

  def remove_block
    block = Block.find(params[:block_id])
    @model.blocks.delete(block)
    flash[:notice] = 'Block was successfully removed from the model.'
    redirect_to @model
  end

  private

  def set_model
    @model = Model.find(params[:id])
  end

  def model_params
    params.require(:model).permit(:model_code, :description, :type_id)
  end
end
