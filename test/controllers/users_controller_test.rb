require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should index" do
    get users_url
    assert_response :error
  end
end
