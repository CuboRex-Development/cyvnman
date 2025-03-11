# frozen_string_literal: true

class Model < ApplicationRecord
  belongs_to :type
  has_and_belongs_to_many :blocks

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id model_code type_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[type blocks]
  end
end
