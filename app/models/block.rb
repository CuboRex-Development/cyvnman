class Block < ApplicationRecord
  has_and_belongs_to_many :models
  has_and_belongs_to_many :parts
end
