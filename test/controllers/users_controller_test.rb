require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.env_config["consider_all_requests_local"] = false
    Rails.application.env_config["action_dispatch.show_exceptions"] = true
  end

  teardown do
    Rails.application.env_config["consider_all_requests_local"] = true
    Rails.application.env_config["action_dispatch.show_exceptions"] = false
  end

  test "should index" do
    puts "should index", Rails.application.env_config["action_dispatch.show_exceptions"]
    get users_url
    assert_response :error
  end
end
