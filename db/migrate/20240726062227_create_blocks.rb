class CreateBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :blocks do |t|
      t.string :block_number
      t.string :block_name
      t.text :description

      t.timestamps
    end
  end
end
