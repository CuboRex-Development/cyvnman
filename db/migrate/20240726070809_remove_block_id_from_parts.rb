class RemoveBlockIdFromParts < ActiveRecord::Migration[7.1]
  def change
    remove_column :parts, :block_id, :integer
  end
end
