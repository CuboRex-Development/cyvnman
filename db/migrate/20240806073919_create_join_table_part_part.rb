class CreateJoinTablePartPart < ActiveRecord::Migration[7.1]
  def change
    create_join_table :parts, :part_associations do |t|
      t.index [:part_id, :part_association_id], unique: true
      t.index [:part_association_id, :part_id], unique: true
    end
  end
end