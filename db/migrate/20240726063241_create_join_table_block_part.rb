# frozen_string_literal: true

class CreateJoinTableBlockPart < ActiveRecord::Migration[7.1]
  def change
    create_join_table :blocks, :parts do |t|
      # t.index [:block_id, :part_id]
      # t.index [:part_id, :block_id]
      t.index :block_id
      t.index :part_id
    end
  end
end
