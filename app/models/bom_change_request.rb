class BomChangeRequest < ApplicationRecord
  belongs_to :type, optional: true
  belongs_to :model, optional: true
  belongs_to :base_bom_version, class_name: 'BomVersion', optional: true

  has_many :bom_change_details, inverse_of: :bom_change_request, dependent: :destroy
  accepts_nested_attributes_for :bom_change_details

  validates :status, presence: true
  # 提出状態のときは変更理由の入力を必須にする例
  validates :reason, presence: true, if: -> { status == 'submitted' }

  # 承認処理の例
  def approve!(approver_name)
    transaction do
      update!(status: 'approved', reviewed_at: Time.current, reviewed_by: approver_name)
      create_new_bom_version!
    end
  end

  # 却下処理の例
  def reject!(approver_name)
    update!(status: 'rejected', reviewed_at: Time.current, reviewed_by: approver_name)
  end

  # 承認時に、base_bom_version をコピーし、差分を適用した新規 BOMVersion を生成する例
  def create_new_bom_version!
    return unless base_bom_version

    new_bom_version = BomVersion.create!(
      type_id: base_bom_version.type_id,
      model_id: base_bom_version.model_id,
      version_label: next_version_label,
      description: "Created by BOMChangeRequest #{id}",
      status: 'approved',
      fixed_at: Time.current,
      created_by: requested_by,
      approved_by: reviewed_by
    )

    # 既存の BOMVersionLine をコピー
    base_bom_version.bom_version_lines.find_each do |line|
      BomVersionLine.create!(
        bom_version: new_bom_version,
        block_id: line.block_id,
        part_id: line.part_id,
        quantity: line.quantity
      )
    end

    # 差分（BOMChangeDetail）を適用
    apply_differences_to(new_bom_version)
  end

  private

  # 差分情報を新しい BOMVersion に反映する処理
  def apply_differences_to(bom_version)
    bom_change_details.each do |detail|
      case detail.change_type
      when 'add'
        BomVersionLine.create!(
          bom_version: bom_version,
          block_id: detail.block_id,
          part_id: detail.part_id,
          quantity: detail.new_quantity
        )
      when 'remove'
        line = bom_version.bom_version_lines.find_by(
          block_id: detail.block_id,
          part_id: detail.part_id
        )
        line&.destroy
      when 'update'
        line = bom_version.bom_version_lines.find_by(
          block_id: detail.block_id,
          part_id: detail.part_id
        )
        line&.update(quantity: detail.new_quantity)
      else
        # 必要に応じた拡張処理
      end
    end
  end

  # 新しいバージョンラベルを生成する例
  def next_version_label
    if base_bom_version.version_label =~ /(\d+)\z/
      num = Regexp.last_match(1).to_i
      base_str = base_bom_version.version_label.sub(/(\d+)\z/, '')
      "#{base_str}#{format('%03d', num + 1)}"
    else
      "#{base_bom_version.version_label}-001"
    end
  end
end
