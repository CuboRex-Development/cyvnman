class Block < ApplicationRecord
  has_and_belongs_to_many :types
  has_and_belongs_to_many :models
  has_and_belongs_to_many :parts

  validates :block_number, presence: true
  validates :block_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "block_name", "block_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["models", "parts"]
  end
end
