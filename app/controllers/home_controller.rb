class HomeController < ApplicationController
  def index
    @types_count = Type.count
    @models_count = Model.count
    @blocks_count = Block.count
    @parts_count = Part.count
    @versions_count = Version.count

    @recent_parts = Part.order(created_at: :desc).limit(5)
    @recent_blocks = Block.order(created_at: :desc).limit(5)
    @recent_models = Model.order(created_at: :desc).limit(5)
  end
end
