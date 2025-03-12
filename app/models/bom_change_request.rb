class BomChangeRequest < ApplicationRecord
  belongs_to :type, optional: true
  belongs_to :model, optional: true
  belongs_to :base_bom_version, class_name: 'BomVersion', optional: true

  has_many :bom_change_details, inverse_of: :bom_change_request, dependent: :destroy
  accepts_nested_attributes_for :bom_change_details

  validates :status, presence: true
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

  # 承認時に、base_bom_version（または対象 Type の最新 BOM）をコピーし、
  # 差分を適用した新規 BOMVersion を生成する
  def create_new_bom_version!
    # base_bom_version が nil なら、対象の Type の最新 BOMVersion をフォールバックとして利用
    base = base_bom_version || BomVersion.latest_for_type(type.id)
    return unless base

    new_bom_version = BomVersion.create!(
      type_id: base.type_id,
      model_id: base.model_id,
      version_label: next_version_label(base),
      description: "Created by BOMChangeRequest #{id}",
      status: 'approved',
      fixed_at: Time.current,
      created_by: requested_by,
      approved_by: reviewed_by
    )

    # 既存の BOMVersionLine をコピー
    base.bom_version_lines.find_each do |line|
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

  # 新しいバージョンラベルを連番で生成する（例："001", "002", ...）
  def next_version_label(base)
    if base.version_label =~ /\A\d+\z/
      new_version = base.version_label.to_i + 1
      format('%03d', new_version)
    else
      "001"
    end
  end
end
