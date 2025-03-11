# frozen_string_literal: true

class AddAttributesToParts < ActiveRecord::Migration[7.1]
  def change
    add_column :parts, :material, :string
    add_column :parts, :nominal_size, :string
    add_column :parts, :part_name_eg, :string
    add_column :parts, :quantity, :integer
    add_column :parts, :image, :string
  end
end
