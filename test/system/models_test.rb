require "application_system_test_case"

class ModelsTest < ApplicationSystemTestCase
  setup do
    @model = models(:one)
  end

  test "visiting the index" do
    visit models_url
    assert_selector "h1", text: "Models"
  end

  test "should create model" do
    visit models_url
    click_on "New model"

    fill_in "Description", with: @model.description
    fill_in "Model code", with: @model.model_code
    fill_in "Type", with: @model.type_id
    click_on "Create Model"

    assert_text "Model was successfully created"
    click_on "Back"
  end

  test "should update Model" do
    visit model_url(@model)
    click_on "Edit this model", match: :first

    fill_in "Description", with: @model.description
    fill_in "Model code", with: @model.model_code
    fill_in "Type", with: @model.type_id
    click_on "Update Model"

    assert_text "Model was successfully updated"
    click_on "Back"
  end

  test "should destroy Model" do
    visit model_url(@model)
    click_on "Destroy this model", match: :first

    assert_text "Model was successfully destroyed"
  end
end
