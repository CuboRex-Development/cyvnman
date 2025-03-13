# frozen_string_literal: true

class CreateBomVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :bom_versions do |t|
      t.references :type, foreign_key: true, null: true # 製品 (Type) 単位の場合。必要なら model とのどちらか一方に調整
      t.references :model, foreign_key: true, null: true
      t.string :version_label, null: false                 # バージョン名（例: "VER-001"）
      t.text :description                                  # 補足情報
      t.string :status, null: false                        # 例: "approved", "archived" など
      t.datetime :fixed_at                                 # 承認日時／バージョン確定日時
      t.string :created_by                                 # 作成者（ユーザー名など）
      t.string :approved_by                                # 承認者
      t.timestamps
    end
    add_index :bom_versions, :status
  end
end
