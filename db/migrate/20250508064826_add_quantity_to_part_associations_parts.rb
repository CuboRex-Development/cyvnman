class AddQuantityToPartAssociationsParts < ActiveRecord::Migration[7.1]
  def change
    add_column :part_associations_parts, :quantity, :integer,
               null: false, default: 0
  end
end
