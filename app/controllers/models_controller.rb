class ModelsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
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
      respond_success(@model, notice: "Model was successfully created.")
    else
      respond_failure(@model, :new)
    end
  end

  def update
    if @model.update(model_params)
      respond_success(@model, notice: "Model was successfully updated.")
    else
      respond_failure(@model, :edit)
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
      respond_success(@model, notice: 'Block was successfully added to the model.')
    else
      flash[:alert] = 'This block is already in the model.'
      redirect_to @model
    end
  end

  def remove_block
    block = Block.find(params[:block_id])
    @model.blocks.delete(block)
    respond_success(@model, notice: 'Block was successfully removed from the model.')
  end

  private

  def set_model
    @model = Model.find(params[:id])
  end

  def model_params
    params.require(:model).permit(:model_code, :description, :type_id)
  end
end
