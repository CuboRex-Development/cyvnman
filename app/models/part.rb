class Part < ApplicationRecord
  has_and_belongs_to_many :blocks
  has_many :versions
end
