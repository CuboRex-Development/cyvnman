class PartLink < ApplicationRecord
  self.table_name  = 'part_associations_parts'  # 既存テーブル名
  self.primary_key = :id                        # ← ★これを追加

  belongs_to :part
  belongs_to :related_part, class_name: 'Part', foreign_key: :part_association_id
end
