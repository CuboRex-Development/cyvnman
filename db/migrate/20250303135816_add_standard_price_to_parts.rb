class AddStandardPriceToParts < ActiveRecord::Migration[7.1]
  def change
    add_column :parts, :standard_price, :decimal, precision: 10, scale: 2
  end
end
