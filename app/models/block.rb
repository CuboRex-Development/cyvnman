class Block < ApplicationRecord
  has_and_belongs_to_many :types
  has_and_belongs_to_many :models
  has_and_belongs_to_many :parts

  validates :block_number, :block_name, presence: true

  # 仮想属性として入力用の値を受け取る
  attr_accessor :block_number_suffix, :type_id_temp

  # 作成前にblock_numberを自動生成
  before_validation :generate_block_number

  # 例: 部品の追加・削除をモデルメソッド化
  def add_part!(part)
    unless parts.exists?(part.id)
      parts << part
    else
      errors.add(:parts, "この部品は既に追加されています")
      false
    end
  end

  def remove_part!(part)
    parts.destroy(part)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "block_name", "block_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["models", "parts"]
  end

  private

  def generate_block_number
    # 仮にtype_id_tempとblock_number_suffixが渡されていれば生成する
    if type_id_temp.present? && block_number_suffix.present?
      type = Type.find_by(id: type_id_temp)
      if type
        self.block_number = "#{type.type_number}-#{block_number_suffix}"
      end
    end
  end
end
