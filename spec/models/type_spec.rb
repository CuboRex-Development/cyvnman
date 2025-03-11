# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Type, type: :model do
  it 'generates type_number automatically on create' do
    type = Type.create!(type_name: 'Test Type', category: 'Carry', description: 'A test type')
    expect(type.type_number).to match(/\A1\d{3}\z/) # category "Carry" → "1xxx" の形式
  end

  it 'validates type_number format' do
    type = Type.new(type_name: 'Test', type_number: '999', category: 'Carry')
    expect(type).not_to be_valid
    expect(type.errors[:type_number]).to include("must be in the format 'XXXX' where X is a digit")
  end
end
