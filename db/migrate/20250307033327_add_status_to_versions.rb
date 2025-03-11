# frozen_string_literal: true

class AddStatusToVersions < ActiveRecord::Migration[7.1]
  def change
    add_column :versions, :status, :string, default: 'Draft'
  end
end
