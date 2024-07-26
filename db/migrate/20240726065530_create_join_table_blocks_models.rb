class CreateJoinTableBlocksModels < ActiveRecord::Migration[7.1]
  def change
    create_join_table :blocks, :models do |t|
      t.index :block_id
      t.index :model_id
    end
  end
end