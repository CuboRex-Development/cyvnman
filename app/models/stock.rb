class Stock < ApplicationRecord
  belongs_to :part
  accepts_nested_attributes_for :part

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  # Ransack で検索可能な属性を明示的に指定
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "part_id", "quantity", "updated_at", "updated_by"]
  end

  # 関連する part の属性も検索できるように許可
  def self.ransackable_associations(auth_object = nil)
    ["part"]
  end
end
