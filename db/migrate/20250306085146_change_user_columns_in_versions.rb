# frozen_string_literal: true

class ChangeUserColumnsInVersions < ActiveRecord::Migration[7.1]
  def change
    # 既存の文字列型カラムを削除（必要に応じて、既存データの移行処理を検討）
    remove_column :versions, :drawn_by, :string
    remove_column :versions, :checked_by, :string
    remove_column :versions, :approved_by, :string

    # ユーザーへの参照として新たに追加
    add_reference :versions, :drawn_by, foreign_key: { to_table: :users }
    add_reference :versions, :checked_by, foreign_key: { to_table: :users }
    add_reference :versions, :approved_by, foreign_key: { to_table: :users }
  end
end
