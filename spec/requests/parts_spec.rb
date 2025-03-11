# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Parts', type: :request do
  let!(:block) { Block.create!(block_number: 'T-001', block_name: 'Block A', description: 'Test') }
  let(:valid_attributes) do
    { part_number_suffix: '001', part_name: 'Part A', description: 'Test part', material: 'Steel', nominal_size: '10',
      part_name_eg: 'Part A Example', quantity: 1 }
  end

  describe 'POST /blocks/:block_id/parts' do
    it 'creates a new part with generated part_number and associates it with the block' do
      expect do
        post block_parts_path(block), params: { part: valid_attributes }
      end.to change(Part, :count).by(1)
      part = Part.last
      expect(part.part_number).to eq("#{block.block_number}-001")
      expect(block.parts).to include(part)
    end
  end
end
