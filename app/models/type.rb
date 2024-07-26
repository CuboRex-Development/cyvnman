class Type < ApplicationRecord
  has_many :models
  has_and_belongs_to_many :blocks
end
