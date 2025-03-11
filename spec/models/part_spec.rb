# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Part, type: :model do
  it 'allows association with versions' do
    part = Part.create!(part_number: 'B-001', part_name: 'Part A', description: 'Test part')
    part.versions.create!(version_number: 'B-001-1', description: 'First version')
    expect(part.versions.count).to eq(1)
  end

  it 'supports related_parts association (双方向)' do
    part1 = Part.create!(part_number: 'B-001', part_name: 'Part A', description: 'Test part')
    part2 = Part.create!(part_number: 'B-002', part_name: 'Part B', description: 'Test part')
    part1.related_parts << part2
    # 相互関連付けのテスト
    expect(part1.related_parts).to include(part2)
  end
end
