# frozen_string_literal: true

class BomChangeDetail < ApplicationRecord
  belongs_to :bom_change_request

  belongs_to :block, optional: true
  belongs_to :part, optional: true

  # "add", "remove", "update" などの変更種別は必須項目としてバリデーションを設定
  validates :change_type, presence: true
end
