# frozen_string_literal: true

class ComparisonsController < ApplicationController
  def index
    @blocks = Block.order(:block_number)
  end

  def compare
    @selected_blocks = Block.where(id: params[:block_ids])
    @parts = Part.joins(:blocks).where(blocks: { id: params[:block_ids] }).distinct
  end
end
