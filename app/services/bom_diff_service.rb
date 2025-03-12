# app/services/bom_diff_service.rb
class BomDiffService
  # 比較対象は Type の現在の状態と、最新の BOMVersion
  def initialize(type)
    @type = type
    @latest_bom = BomVersion.latest_for_type(@type.id)
  end

  # 差分をハッシュの配列として返す
  # 例: [{ block_id: X, part_id: Y, old_quantity: 3, new_quantity: 5, change_type: 'update' }, ...]
  def differences
    current_data = extract_current_data
    snapshot_data = extract_snapshot_data

    diffs = []

    # 現在の状態を走査し、snapshot に存在するか、数量が変わっているかを比較
    current_data.each do |key, current_qty|
      snapshot_qty = snapshot_data[key] || 0
      if current_qty != snapshot_qty
        diffs << {
          block_id: key[:block_id],
          part_id: key[:part_id],
          old_quantity: snapshot_qty,
          new_quantity: current_qty,
          change_type: snapshot_qty.zero? ? 'add' : (current_qty.zero? ? 'remove' : 'update')
        }
      end
    end

    # snapshot にあって current に存在しない場合（削除されたケース）
    snapshot_data.each do |key, snapshot_qty|
      unless current_data.key?(key)
        diffs << {
          block_id: key[:block_id],
          part_id: key[:part_id],
          old_quantity: snapshot_qty,
          new_quantity: 0,
          change_type: 'remove'
        }
      end
    end

    diffs
  end

  private

  # 現在の Type の最新状態を取得する
  # 例：Type に関連する Block の全 BlockPart からデータを構築
  def extract_current_data
    data = {}
    @type.blocks.includes(:block_parts).each do |block|
      block.block_parts.each do |bp|
        key = { block_id: block.id, part_id: bp.part_id }
        data[key] = bp.quantity
      end
    end
    data
  end

  # 最新の BOMVersion からスナップショットのデータを取得する
  def extract_snapshot_data
    data = {}
    return data unless @latest_bom

    @latest_bom.bom_version_lines.each do |line|
      key = { block_id: line.block_id, part_id: line.part_id }
      data[key] = line.quantity
    end
    data
  end
end
