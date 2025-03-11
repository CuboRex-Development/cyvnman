# frozen_string_literal: true

# app/controllers/concerns/controller_response_handler.rb
module ControllerResponseHandler
  extend ActiveSupport::Concern

  # 成功時のリダイレクトとフラッシュ設定
  def respond_success(resource, notice: nil, redirect_url: nil)
    flash[:notice] = notice if notice.present?
    redirect_to(redirect_url || resource)
  end

  # 失敗時のレンダリングとエラーメッセージ設定
  def respond_failure(resource, action)
    flash.now[:alert] = resource.errors.full_messages.join(', ')
    render action, status: :unprocessable_entity
  end
end
