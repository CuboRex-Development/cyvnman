class CreateVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :versions do |t|
      t.string :version_number
      t.text :description
      t.references :part, null: false, foreign_key: true

      t.timestamps
    end
  end
end
