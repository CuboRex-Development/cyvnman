class PopulateStocksForExistingParts < ActiveRecord::Migration[7.1]
  class MigrationPart < ApplicationRecord
    self.table_name = 'parts'
    has_one :stock, class_name: 'Stock', foreign_key: 'part_id'
  end

  def up
    MigrationPart.find_each do |part|
      unless part.stock
        Stock.create!(part_id: part.id, quantity: 0)
      end
    end
  end

  def down
    Stock.delete_all
  end
end
