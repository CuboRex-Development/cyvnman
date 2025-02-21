class Version < ApplicationRecord
  belongs_to :part
  has_one_attached :drawing_image

  # 仮想属性：サフィックス
  attr_accessor :version_number_suffix

  # 作成前にversion_numberを自動生成
  before_validation :generate_version_number, on: :create

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "version_number", "part_id", "file_path", "scale", "sheet_size", "unit", "drawn_by", "checked_by", "approved_by", "drawn_date", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["part"]
  end

  private

  def generate_version_number
    # 関連するpartが存在し、version_number_suffixが入力されていれば生成する
    if version_number_suffix.present? && part.present? && part.part_number.present?
      self.version_number = "#{part.part_number}-#{version_number_suffix}"
    end
  end
end
