class Stock < ApplicationRecord
  belongs_to :part
  accepts_nested_attributes_for :part

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
