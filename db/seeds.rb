# db/seeds.rb

# 各 Type ごとに初期 BOM バージョンが存在しなければ生成する例
Type.find_each do |type|
  unless BomVersion.exists?(type_id: type.id)
    puts "Creating initial BOM Version for Type: #{type.type_name}"
    
    # 初期 BOMVersion の作成。version_label は "VER-001" としています。
    bom_version = BomVersion.create!(
      type_id: type.id,
      version_label: "VER-001",
      description: "Initial BOM for #{type.type_name}",
      status: "approved",
      fixed_at: Time.current,
      created_by: "system",
      approved_by: "system"
    )
    
    # Type に紐づく Block を取得する。Type と Block の関連付けがある前提です。
    type.blocks.find_each do |block|
      # Block に含まれる Part 情報（BlockPart 経由）を BOMVersionLine として登録
      block.block_parts.find_each do |bp|
        BomVersionLine.create!(
          bom_version: bom_version,
          block_id: block.id,
          part_id: bp.part_id,
          quantity: bp.quantity
        )
      end
    end
  end
end
