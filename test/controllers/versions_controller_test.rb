# frozen_string_literal: true

require 'test_helper'

class VersionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @version = versions(:one)
  end

  test 'should get index' do
    get versions_url
    assert_response :success
  end

  test 'should get new' do
    get new_version_url
    assert_response :success
  end

  test 'should create version' do
    assert_difference('Version.count') do
      post versions_url,
           params: { version: { description: @version.description, part_id: @version.part_id,
                                version_number: @version.version_number } }
    end

    assert_redirected_to version_url(Version.last)
  end

  test 'should show version' do
    get version_url(@version)
    assert_response :success
  end

  test 'should get edit' do
    get edit_version_url(@version)
    assert_response :success
  end

  test 'should update version' do
    patch version_url(@version),
          params: { version: { description: @version.description, part_id: @version.part_id,
                               version_number: @version.version_number } }
    assert_redirected_to version_url(@version)
  end

  test 'should destroy version' do
    assert_difference('Version.count', -1) do
      delete version_url(@version)
    end

    assert_redirected_to versions_url
  end
end
