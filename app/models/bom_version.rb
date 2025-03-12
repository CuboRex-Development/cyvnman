class BomVersion < ApplicationRecord
  belongs_to :type, optional: true
  belongs_to :model, optional: true

  has_many :bom_version_lines, dependent: :destroy

  validates :version_label, presence: true
  validates :status, presence: true

  # 承認済み BOM を取得するためのスコープ例
  scope :approved, -> { where(status: 'approved') }

  # 例: 指定した製品の最新の承認済み BOM を取得する
  def self.latest_for_type(type_id)
    approved.where(type_id: type_id).order(fixed_at: :desc).first
  end
end
