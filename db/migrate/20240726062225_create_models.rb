class CreateModels < ActiveRecord::Migration[7.1]
  def change
    create_table :models do |t|
      t.string :model_code
      t.text :description
      t.references :type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
