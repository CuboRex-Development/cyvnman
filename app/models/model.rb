class Model < ApplicationRecord
  belongs_to :type
  has_and_belongs_to_many :blocks

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "model_code", "type_id", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["type", "blocks"]
  end
end
