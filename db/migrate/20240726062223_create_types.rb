class CreateTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :types do |t|
      t.string :type_name
      t.string :type_number
      t.text :description

      t.timestamps
    end
  end
end
