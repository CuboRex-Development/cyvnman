class HomeController < ApplicationController
  def index
    @recent_updates = {
      types: Type.order(updated_at: :desc).limit(5),
      models: Model.order(updated_at: :desc).limit(5),
      blocks: Block.order(updated_at: :desc).limit(5),
      parts: Part.order(updated_at: :desc).limit(5),
      versions: Version.order(updated_at: :desc).limit(5)
    }

    @stats = {
      types: Type.count,
      models: Model.count,
      blocks: Block.count,
      parts: Part.count,
      versions: Version.count
    }

    if params[:q].present?
      @q = params[:q]
      @types = Type.ransack(type_name_or_type_number_cont: @q).result(distinct: true)
      @models = Model.ransack(model_code_or_description_cont: @q).result(distinct: true)
      @blocks = Block.ransack(block_name_or_block_number_cont: @q).result(distinct: true)
      @parts = Part.ransack(part_name_or_part_number_cont: @q).result(distinct: true)
      @versions = Version.ransack(version_number_or_description_cont: @q).result(distinct: true)
    else
      @types = Type.none
      @models = Model.none
      @blocks = Block.none
      @parts = Part.none
      @versions = Version.none
    end
  end
end
