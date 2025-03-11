# frozen_string_literal: true

class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :part_number
      t.string :part_name
      t.text :description
      t.references :block, null: false, foreign_key: true

      t.timestamps
    end
  end
end
