# frozen_string_literal: true

class AddTitleToBomChangeRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :bom_change_requests, :title, :string
  end
end
