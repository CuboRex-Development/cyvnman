# frozen_string_literal: true

class Part < ApplicationRecord
  # ─── 仮想属性 ───────────────────────────────────────────
  attr_accessor :primary_block_id

  # ─── ① アソシエーション ──────────────────────────────
  has_many :block_parts, dependent: :destroy
  has_many :blocks,      through: :block_parts
  has_many :versions
  has_one  :stock, dependent: :destroy

  #  quantity を持つ中間モデル (part_associations_parts)
  has_many :part_links,         class_name: 'PartLink',
                                foreign_key: :part_id,
                                dependent: :destroy
  has_many :related_parts,      through: :part_links,
                                source:  :related_part

  has_one_attached :image

  # ─── ② バリデーション ────────────────────────────────
  validates :part_number, :part_name, presence: true
  validates :standard_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # ─── ③ 採番 ─────────────────────────────────────────
  before_validation :generate_part_number, on: :create

  # ─── ④ 公開 API ────────────────────────────────────
  # A に B を qty 個リンクする（既存なら数量を足す）
  def add_related_part!(other_part, qty = 1)
    qty = qty.to_i
    raise ArgumentError, '数量は 1 以上で指定してください' if qty <= 0

    Part.transaction do
      link = part_links.where(related_part: other_part).first_or_initialize
      link.quantity = link.quantity.to_i + qty
      link.save!

      sync_block_parts_quantity(other_part, qty)
    end
  end

  # A⇆B のリンクから qty 個だけ外す（0 なら行ごと削除）
  def remove_related_part!(other_part, qty = 1)
    qty = qty.to_i
    raise ArgumentError, '数量は 1 以上' if qty <= 0

    Part.transaction do
      link = part_links.find_by!(related_part: other_part)
      link.quantity -= qty
      link.quantity <= 0 ? link.destroy! : link.save!

      sync_block_parts_quantity(other_part, -qty)
    end
  end

  # 全ブロック合計でこの部品が何個使われているか
  def total_used_quantity
    BlockPart.where(part_id: id).sum(:quantity)
  end

  # ─── ⑤ Ransack 設定（そのまま）─────────────────────
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id part_name part_number updated_at material nominal_size
       part_name_eg quantity image]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[blocks versions related_parts]
  end

  # ビュー用ヘルパ
  def part_number_and_name
    "#{part_number} - #{part_name}"
  end

  # ─── ⑥ プライベートメソッド ─────────────────────────
  private

  # ブロック採番
  def generate_part_number
    return unless primary_block_id.present?

    block = Block.find_by(id: primary_block_id)
    return unless block&.block_number.present?

    existing = Part.where('part_number LIKE ?', "#{block.block_number}-%")
                   .pluck(:part_number)
    max_suffix = existing.map { |num| num.split('-').last.to_i }.max || 0
    self.part_number = format('%<prefix>s-%<num>03d',
                              prefix: block.block_number,
                              num:    max_suffix + 1)
  end

  # BlockPart.quantity を ±qty 同期
  def sync_block_parts_quantity(other_part, qty)
    if qty.positive?
      blocks.each          { |b| b.add_part!(other_part, qty) }
      other_part.blocks.each { |b| b.add_part!(self,       qty) }
    else
      blocks.each          { |b| b.subtract_part!(other_part, -qty) }
      other_part.blocks.each { |b| b.subtract_part!(self,       -qty) }
    end
  end
end
