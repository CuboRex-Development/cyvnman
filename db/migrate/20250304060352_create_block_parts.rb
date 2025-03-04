class CreateBlockParts < ActiveRecord::Migration[7.1]
  def change
    create_table :block_parts do |t|
      t.references :block, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
