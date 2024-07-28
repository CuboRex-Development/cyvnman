class Part < ApplicationRecord
  has_and_belongs_to_many :blocks
  has_many :versions

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "part_name", "part_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["blocks", "versions"]
  end
end
