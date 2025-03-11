# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/stocks/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/stocks/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/stocks/update'
      expect(response).to have_http_status(:success)
    end
  end
end
