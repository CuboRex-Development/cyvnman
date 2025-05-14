class AddIdToPartAssociationsParts < ActiveRecord::Migration[7.1]
  def change
    add_column :part_associations_parts, :id, :primary_key
  end
end
