# frozen_string_literal: true

class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.references :part, null: false, foreign_key: true
      t.integer :quantity, default: 0, null: false

      t.timestamps
    end
  end
end
