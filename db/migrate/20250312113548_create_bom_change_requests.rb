class CreateBomChangeRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :bom_change_requests do |t|
      t.references :type, foreign_key: true, null: true          # 製品（Type）単位の場合。必要に応じて model に調整
      t.references :model, foreign_key: true, null: true
      t.references :base_bom_version, null: true, foreign_key: { to_table: :bom_versions } # 変更のベースとなる BOMVersion
      t.text :reason                                             # 変更理由・背景
      t.string :requested_by                                     # 申請者
      t.string :status, default: 'draft'                         # ステータス: draft, submitted, approved, rejected
      t.datetime :submitted_at                                   # 提出日時（status が submitted に変更された時）
      t.datetime :reviewed_at                                    # レビュー完了日時（承認 or 却下時）
      t.string :reviewed_by                                      # 承認(却下)者
      t.timestamps
    end
    add_index :bom_change_requests, :status
  end
end
