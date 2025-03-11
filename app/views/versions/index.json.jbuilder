# frozen_string_literal: true

json.array! @versions, partial: 'versions/version', as: :version
