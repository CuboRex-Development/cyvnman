# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Versions', type: :request do
  let!(:part) { Part.create!(part_number: 'B-001', part_name: 'Part A', description: 'Test part') }
  let(:valid_attributes) do
    { version_number_suffix: '001', description: 'Version 1', scale: '1:1', sheet_size: 'A4', unit: 'mm',
      drawn_by: 'User', checked_by: 'User2', approved_by: 'User3', drawn_date: '2023-01-01' }
  end

  describe 'POST /parts/:part_id/versions' do
    it 'creates a new version with generated version_number and associates it with the part' do
      expect do
        post part_versions_path(part), params: { version: valid_attributes }
      end.to change(Version, :count).by(1)
      version = Version.last
      expect(version.version_number).to eq("#{part.part_number}-001")
      expect(version.part).to eq(part)
    end
  end
end
