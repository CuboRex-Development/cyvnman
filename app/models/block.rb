# frozen_string_literal: true

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
    # part_id を条件にしてレコードを取得
    bp = block_parts.where(part_id: part.id).first_or_initialize
    # 新規の場合、明示的に関連付けを設定
    bp.part = part if bp.new_record?
    bp.quantity = bp.new_record? ? quantity : bp.quantity + quantity
    Rails.logger.debug "BlockPart save failed: #{bp.errors.full_messages}" unless bp.save
    bp
  end

  def remove_part!(part)
    block_parts.find_by(part:)&.destroy
  end

  # 各 BlockPart の quantity と、関連 Part の standard_price の積の合計を算出
  def total_related_price
    block_parts.sum { |bp| (bp.part.standard_price || 0) * bp.quantity }
  end

  # app/models/block.rb
  def quantity_for(part)
    bp = block_parts.find_by(part:)
    bp ? bp.quantity : 0
  end

  def generate_block_number
    return unless primary_type_id.present?

      type = Type.find_by(id: primary_type_id)
      return unless type

        existing_numbers = Block.where('block_number LIKE ?', "#{type.type_number}-%").pluck(:block_number)
        max_suffix = existing_numbers.map { |num| num.split('-').last.to_i }.max || 0
        new_suffix = (max_suffix + 1).to_s.rjust(3, '0')
        self.block_number = "#{type.type_number}-#{new_suffix}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id block_name block_number updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[models parts]
  end
end
