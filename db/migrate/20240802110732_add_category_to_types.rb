class AddCategoryToTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :types, :category, :string
    add_index :types, :category
  end
end
