# frozen_string_literal: true

class BlockPart < ApplicationRecord
  belongs_to :block
  belongs_to :part

  validates :quantity, numericality: { greater_than: 0 }
end
