class Stock < ApplicationRecord
  belongs_to :part

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
