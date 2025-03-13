# frozen_string_literal: true

class BomVersionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  # GET /bom_versions
  def index
    @bom_versions = BomVersion.order(fixed_at: :desc)
  end

  # GET /bom_versions/:id
  def show
    @bom_version = BomVersion.find(params[:id])
  end
end
