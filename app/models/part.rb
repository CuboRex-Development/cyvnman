class Part < ApplicationRecord
  has_and_belongs_to_many :blocks
  has_many :versions

  has_and_belongs_to_many :related_parts,
                          class_name: 'Part',
                          join_table: :part_associations_parts,
                          foreign_key: :part_id,
                          association_foreign_key: :part_association_id

  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "part_name", "part_number", "updated_at", "material", "nominal_size", "part_name_eg", "quantity", "image"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["blocks", "versions", "related_parts"]
  end

  def part_number_and_name
    "#{part_number} - #{part_name}"
  end
end