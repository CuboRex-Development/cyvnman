class Model < ApplicationRecord
  belongs_to :type
  has_many :blocks
end
