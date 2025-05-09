# frozen_string_literal: true

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

  # app/models/part.rb
  def remove_related_part!(other_part, qty = 1)
    qty = qty.to_i
    raise ArgumentError, '数量は 1 以上' if qty <= 0

    Part.transaction do
      # ① BOM を双方のブロックで -qty
      blocks.each          { |b| b.subtract_part!(other_part, qty) }
      other_part.blocks.each { |b| b.subtract_part!(self,       qty) }

      # ② HABTM を物理的に外す（残り数量ゼロになった時だけ外したいなら条件分岐も可）
      related_parts.destroy(other_part)
    end
  end


  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id part_name part_number updated_at material nominal_size
       part_name_eg quantity image]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[blocks versions related_parts]
  end

  def part_number_and_name
    "#{part_number} - #{part_name}"
  end

  def add_related_part!(other_part, qty = 1)
    qty = qty.to_i
    raise ArgumentError, '数量は 1 以上で指定してください' if qty <= 0
    return if related_parts.exists?(other_part.id) # 重複防止

    Part.transaction do
      related_parts << other_part                 # HABTM へ挿入
      sync_block_parts_quantity(other_part, qty)  # ← 数量同期 (下で定義)
    end
  end

  private

  def generate_part_number
    return unless primary_block_id.present?

      block = Block.find_by(id: primary_block_id)
      return unless block && block.block_number.present?

        existing_numbers = Part.where('part_number LIKE ?', "#{block.block_number}-%").pluck(:part_number)
        max_suffix = existing_numbers.map { |num| num.split('-').last.to_i }.max || 0
        new_suffix = (max_suffix + 1).to_s.rjust(3, '0')
        self.part_number = "#{block.block_number}-#{new_suffix}"
  end

  def sync_block_parts_quantity(other_part, qty)
    blocks.each { |b| b.add_part!(other_part, qty) }
    other_part.blocks.each { |b| b.add_part!(self, qty) }
  end
end
