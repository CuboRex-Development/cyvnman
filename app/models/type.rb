class Type < ApplicationRecord
  has_many :models
  has_and_belongs_to_many :blocks

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "type_name", "type_number", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["models", "blocks"]
  end

  CATEGORY_CODES = {
    'Carry' => '1',
    'Applicate' => '2',
    'Collect' => '3',
    'Other' => '9'
  }

  validates :type_number, presence: true, uniqueness: true, format: { with: /\A[1-3,9]\d{3}\z/, message: "must be in the format 'XXXX' where X is a digit" }
  validate :validate_type_number_category
  before_validation :set_type_number, on: :create

  private

  def validate_type_number_category
    return if type_number.blank?
    category_code = type_number[0]
    unless CATEGORY_CODES.values.include?(category_code)
      errors.add(:type_number, "must start with a valid category code (1, 2, 3, or 9)")
    end
  end

  def set_type_number
    return if type_number.present?
    category_code = CATEGORY_CODES[category] || '9'
    serial_number = Type.where("type_number LIKE ?", "#{category_code}%")
                        .maximum("CAST(SUBSTRING(type_number, 2, 3) AS INTEGER)") || 0
    serial_number += 1
    self.type_number = "#{category_code}#{serial_number.to_s.rjust(3, '0')}"
  end
end
