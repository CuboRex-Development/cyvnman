# frozen_string_literal: true

class AddDrawingAttributesToVersions < ActiveRecord::Migration[7.1]
  def change
    add_column :versions, :file_path, :string
    add_column :versions, :scale, :string
    add_column :versions, :sheet_size, :string
    add_column :versions, :unit, :string
    add_column :versions, :drawn_by, :string
    add_column :versions, :checked_by, :string
    add_column :versions, :approved_by, :string
    add_column :versions, :drawn_date, :date
  end
end
