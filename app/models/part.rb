class Part < ApplicationRecord
  attr_accessor :primary_block_id
  
  has_many :block_parts, dependent: :destroy
  has_many :blocks, through: :block_parts
  has_many :versions
  has_one :stock, dependent: :destroy

  has_and_belongs_to_many :related_parts,
                          class_name: 'Part',
                          join_table: :part_associations_parts,
                          foreign_key: :part_id,
                          association_foreign_key: :part_association_id

  has_one_attached :image

  validates :part_number, :part_name, presence: true
  validates :standard_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true


  before_validation :generate_part_number, on: :create

  def total_used_quantity
    BlockPart.where(part_id: id).sum(:quantity)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "part_name", "part_number", "updated_at", "material", "nominal_size", "part_name_eg", "quantity", "image"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["blocks", "versions", "related_parts"]
  end

  def part_number_and_name
    "#{part_number} - #{part_name}"
  end

  private

  def generate_part_number
    if self.primary_block_id.present?
      block = Block.find_by(id: self.primary_block_id)
      if block && block.block_number.present?
        existing_numbers = Part.where("part_number LIKE ?", "#{block.block_number}-%").pluck(:part_number)
        max_suffix = existing_numbers.map { |num| num.split('-').last.to_i }.max || 0
        new_suffix = (max_suffix + 1).to_s.rjust(3, '0')
        self.part_number = "#{block.block_number}-#{new_suffix}"
      end
    end
  end
end
