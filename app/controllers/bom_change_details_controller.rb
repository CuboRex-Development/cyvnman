# app/controllers/bom_change_details_controller.rb
class BomChangeDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bom_change_request

  # POST /bom_change_requests/:bom_change_request_id/bom_change_details
  def create
    @detail = @bom_change_request.bom_change_details.build(bom_change_detail_params)
    if @detail.save
      redirect_to @bom_change_request, notice: 'Change detail added successfully.'
    else
      redirect_to @bom_change_request, alert: @detail.errors.full_messages.join(', ')
    end
  end

  # DELETE /bom_change_requests/:bom_change_request_id/bom_change_details/:id
  def destroy
    @detail = @bom_change_request.bom_change_details.find(params[:id])
    @detail.destroy
    redirect_to @bom_change_request, notice: 'Change detail removed successfully.'
  end

  private

  def set_bom_change_request
    @bom_change_request = BomChangeRequest.find(params[:bom_change_request_id])
  end

  def bom_change_detail_params
    params.require(:bom_change_detail).permit(:block_id, :part_id, :old_quantity, :new_quantity, :change_description, :change_type)
  end
end
