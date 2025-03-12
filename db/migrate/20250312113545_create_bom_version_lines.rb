class CreateBomVersionLines < ActiveRecord::Migration[7.1]
  def change
    create_table :bom_version_lines do |t|
      t.references :bom_version, null: false, foreign_key: true  # BOMVersion との紐付け
      t.references :block, foreign_key: true                      # ブロック単位の場合（オプション）
      t.references :part, foreign_key: true                       # 部品単位の場合（オプション）
      t.integer :quantity, null: false, default: 1                # 使用数（必須・1以上）
      t.timestamps
    end
  end
end
