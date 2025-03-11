# frozen_string_literal: true

json.extract! type, :id, :type_name, :type_number, :description, :created_at, :updated_at
json.url type_url(type, format: :json)
