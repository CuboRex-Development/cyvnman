# frozen_string_literal: true

class CreateBomChangeDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :bom_change_details do |t|
      t.references :bom_change_request, null: false, foreign_key: true  # BOMChangeRequest との紐付け
      t.references :block, foreign_key: true                            # ブロックID（変更対象）
      t.references :part, foreign_key: true                             # 部品ID（変更対象）
      t.integer :old_quantity                                           # 変更前の数量
      t.integer :new_quantity                                           # 変更後の数量
      t.text :change_description                                        # 変更内容の詳細（理由など）
      t.string :change_type                                             # 例: "add", "remove", "update"
      t.timestamps
    end
  end
end
