# frozen_string_literal: true

json.extract! block, :id, :block_number, :block_name, :description, :created_at, :updated_at
json.url block_url(block, format: :json)
