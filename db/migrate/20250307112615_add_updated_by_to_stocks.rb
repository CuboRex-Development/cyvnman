class AddUpdatedByToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :updated_by, :string
  end
end
