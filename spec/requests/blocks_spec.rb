require 'rails_helper'

RSpec.describe "Blocks", type: :request do
  let!(:type) { Type.create!(type_name: "Test Type", category: "Carry", description: "Test") }
  let(:valid_attributes) {
    { block_number_suffix: "001", block_name: "Block A", description: "A test block", type_id: type.id }
  }

  describe "POST /blocks" do
    it "creates a new Block with generated block_number and associated type" do
      expect {
        post blocks_path, params: { block: valid_attributes }
      }.to change(Block, :count).by(1)
      block = Block.last
      expect(block.block_number).to eq("#{type.type_number}-001")
      expect(block.types).to include(type)
    end
  end

  describe "PATCH /blocks/:id" do
    let!(:block) { Block.create!(block_number: "000-001", block_name: "Block A", description: "Test") }
    before { block.types << type }
    it "updates the block_number on update" do
      patch block_path(block), params: { block: valid_attributes }
      block.reload
      expect(block.block_number).to eq("#{type.type_number}-001")
    end
  end
end
