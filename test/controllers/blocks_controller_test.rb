# frozen_string_literal: true

require 'test_helper'

class BlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @block = blocks(:one)
  end

  test 'should get index' do
    get blocks_url
    assert_response :success
  end

  test 'should get new' do
    get new_block_url
    assert_response :success
  end

  test 'should create block' do
    assert_difference('Block.count') do
      post blocks_url,
           params: { block: { block_name: @block.block_name, block_number: @block.block_number,
                              description: @block.description } }
    end

    assert_redirected_to block_url(Block.last)
  end

  test 'should show block' do
    get block_url(@block)
    assert_response :success
  end

  test 'should get edit' do
    get edit_block_url(@block)
    assert_response :success
  end

  test 'should update block' do
    patch block_url(@block),
          params: { block: { block_name: @block.block_name, block_number: @block.block_number,
                             description: @block.description } }
    assert_redirected_to block_url(@block)
  end

  test 'should destroy block' do
    assert_difference('Block.count', -1) do
      delete block_url(@block)
    end

    assert_redirected_to blocks_url
  end
end
