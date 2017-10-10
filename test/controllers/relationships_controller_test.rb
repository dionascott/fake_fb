require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get relationships_new_url
    assert_response :success
  end

  test "should get edit" do
    get relationships_edit_url
    assert_response :success
  end

  test "should get index" do
    get relationships_index_url
    assert_response :success
  end

end
