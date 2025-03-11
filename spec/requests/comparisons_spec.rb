# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comparisons', type: :request do
  let!(:block1) { Block.create!(block_number: 'B-001', block_name: 'Block 1', description: 'Test') }
  let!(:block2) { Block.create!(block_number: 'B-002', block_name: 'Block 2', description: 'Test') }
  let!(:part1) { Part.create!(part_number: 'B-001-001', part_name: 'Part 1', description: 'Test') }
  let!(:part2) { Part.create!(part_number: 'B-002-001', part_name: 'Part 2', description: 'Test') }

  before do
    block1.parts << part1
    block2.parts << part2
  end

  describe 'GET /comparisons/compare' do
    it 'returns a successful response including parts from selected blocks' do
      get compare_comparisons_path, params: { block_ids: [block1.id, block2.id] }
      expect(response).to have_http_status(:success)
      expect(response.body).to include(part1.part_name)
      expect(response.body).to include(part2.part_name)
    end
  end
end
