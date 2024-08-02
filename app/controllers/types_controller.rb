class TypesController < ApplicationController
  before_action :set_type, only: %i[ show edit update destroy ]

  def index
    @q = Type.ransack(params[:q])
    @q.sorts = 'type_number asc' if @q.sorts.empty?
    @types = @q.result(distinct: true)
  end

  def show
  end

  def new
    @type = Type.new
  end

  def edit
  end

  def create
    @type = Type.new(type_params)

    if @type.save
      redirect_to @type, notice: "Type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @type.update(type_params)
      redirect_to @type, notice: "Type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @type.destroy
    redirect_to types_url, notice: "Type was successfully destroyed."
  end

  private

  def set_type
    @type = Type.find(params[:id])
  end

  def type_params
    params.require(:type).permit(:type_name, :type_number, :category,:description)
  end
end
