class Block < ApplicationRecord
  # 既存のアソシエーションなど
  has_and_belongs_to_many :types
  has_and_belongs_to_many :models
  has_and_belongs_to_many :parts

  validates :block_number, :block_name, presence: true

  # 仮想属性として採番用のタイプIDを保持
  attr_accessor :primary_type_id

  before_validation :generate_block_number, on: :create

 # 指定した Part をブロックに追加する（既に存在していなければ）
  def add_part!(part)
    unless parts.exists?(part.id)
      parts << part
    end
  end

  # 指定した Part をブロックから削除する
  def remove_part!(part)
    parts.destroy(part)
  end

  # 自動連番採番ロジック
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

  # Block に関連するパーツの standard_price の総額を計算するメソッド
  def total_standard_price
    # 標準価格が nil のパーツがあっても 0 として扱うようにする
    parts.sum { |part| part.standard_price || 0 }
  end

  # 以下、ransackable_attributes などはそのままで
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "block_name", "block_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["models", "parts"]
  end
end