class Type < ApplicationRecord
  has_many :models
  has_and_belongs_to_many :blocks

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "type_name", "type_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["models", "blocks"]
  end
end
