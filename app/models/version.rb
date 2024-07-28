class Version < ApplicationRecord
  belongs_to :part
  has_one_attached :drawing_image

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "version_number", "part_id", "file_path", "scale", "sheet_size", "unit", "drawn_by", "checked_by", "approved_by", "drawn_date", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["part"]
  end
end
