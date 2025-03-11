# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Version, type: :model do
  it 'belongs to a part' do
    part = Part.create!(part_number: 'B-001', part_name: 'Part A', description: 'Test part')
    version = part.versions.create!(version_number: 'B-001-1', description: 'Version 1')
    expect(version.part).to eq(part)
  end
end
