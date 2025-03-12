class BomVersionLine < ApplicationRecord
  belongs_to :bom_version
  belongs_to :block, optional: true
  belongs_to :part, optional: true

  validates :quantity, numericality: { greater_than: 0 }
end
