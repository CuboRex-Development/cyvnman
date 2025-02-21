require 'rails_helper'

RSpec.describe Block, type: :model do
  it 'requires block_number and block_name' do
    block = Block.new
    expect(block).not_to be_valid

    block.block_number = "T-001"
    block.block_name = "Block A"
    expect(block).to be_valid
  end
end
