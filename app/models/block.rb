class Block < ApplicationRecord
  has_many :block_parts, dependent: :destroy
  has_many :parts, through: :block_parts

  has_and_belongs_to_many :types
  has_and_belongs_to_many :models

  validates :block_number, :block_name, presence: true

  attr_accessor :primary_type_id
  before_validation :generate_block_number, on: :create

  # ブロックにパーツを追加するときは、BlockPart 経由で数量を記録する
  def add_part!(part, quantity = 1)
    bp = block_parts.find_or_initialize_by(part: part)
    bp.quantity = bp.new_record? ? quantity : bp.quantity + quantity
    bp.save
  end

  def remove_part!(part)
    block_parts.find_by(part: part)&.destroy
  end

  # 各 BlockPart の quantity と、関連 Part の standard_price の積の合計を算出
  def total_related_price
    block_parts.sum { |bp| (bp.part.standard_price || 0) * bp.quantity }
  end

  def generate_block_number
    if primary_type_id.present?
      type = Type.find_by(id: primary_type_id)
      if type
        existing_numbers = Block.where("block_number LIKE ?", "#{type.type_number}-%").pluck(:block_number)
        max_suffix = existing_numbers.map { |num| num.split('-').last.to_i }.max || 0
        new_suffix = (max_suffix + 1).to_s.rjust(3, '0')
        self.block_number = "#{type.type_number}-#{new_suffix}"
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "block_name", "block_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["models", "parts"]
  end
end
