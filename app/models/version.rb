class Version < ApplicationRecord
  belongs_to :part
  has_one_attached :drawing_image

  before_validation :generate_version_number, on: :create

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "version_number", "part_id", "file_path", "scale", "sheet_size", "unit", "drawn_by", "checked_by", "approved_by", "drawn_date", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["part"]
  end

  private

  def generate_version_number
    if part.present? && part.part_number.present?
      # 同じ部品内の既存のバージョン番号を取得
      existing_numbers = part.versions.where("version_number LIKE ?", "#{part.part_number}-%").pluck(:version_number)
      max_suffix = existing_numbers.map { |num| num.split('-').last.to_i }.max || 0
      new_suffix = (max_suffix + 1).to_s.rjust(3, '0')
      self.version_number = "#{part.part_number}-#{new_suffix}"
    end
  end
end
