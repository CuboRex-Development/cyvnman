class Part < ApplicationRecord
  has_and_belongs_to_many :blocks
  has_many :versions

  has_and_belongs_to_many :related_parts,
                          class_name: 'Part',
                          join_table: :part_associations_parts,
                          foreign_key: :part_id,
                          association_foreign_key: :part_association_id

  has_one_attached :image

  validates :part_number, :part_name, presence: true

  # 仮想属性：所属ブロック（primary_block_id）とサフィックス
  attr_accessor :part_number_suffix, :primary_block_id

  # 作成前にpart_numberを自動生成
  before_validation :generate_part_number, on: :create

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
    # primary_block_id と part_number_suffix が指定されていれば生成する
    if part_number_suffix.present? && primary_block_id.present?
      block = Block.find_by(id: primary_block_id)
      if block && block.block_number.present?
        self.part_number = "#{block.block_number}-#{part_number_suffix}"
      end
    end
  end
end
