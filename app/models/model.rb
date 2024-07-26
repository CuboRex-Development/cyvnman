class Model < ApplicationRecord
  belongs_to :type
  has_and_belongs_to_many :blocks
end
