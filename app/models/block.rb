class Block < ApplicationRecord
  has_and_belongs_to_many :types
  has_and_belongs_to_many :models
  has_and_belongs_to_many :parts

  validates :block_number, presence: true
  validates :block_name, presence: true
end
