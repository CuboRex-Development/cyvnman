# frozen_string_literal: true

class CreateJoinTableTypesBlocks < ActiveRecord::Migration[7.1]
  def change
    create_join_table :types, :blocks do |t|
      t.index %i[type_id block_id]
      t.index %i[block_id type_id]
    end
  end
end
