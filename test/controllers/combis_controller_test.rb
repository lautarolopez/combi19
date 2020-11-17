require 'test_helper'

class CombisControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get combis_new_url
    assert_response :success
  end

  test "should get index" do
    get combis_index_url
    assert_response :success
  end

  test "should get edit" do
    get combis_edit_url
    assert_response :success
  end

end
