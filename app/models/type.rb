class Type < ApplicationRecord
  has_many :models
  has_many :blocks, through: :models
end
