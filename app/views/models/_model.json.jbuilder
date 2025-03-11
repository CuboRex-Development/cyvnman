# frozen_string_literal: true

json.extract! model, :id, :model_code, :description, :type_id, :created_at, :updated_at
json.url model_url(model, format: :json)
