require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get not_found" do
    puts "ErrorsControllerTest", Rails.application.env_config["action_dispatch.show_exceptions"]
    get errors_not_found_url
    assert_response :not_found
  end

  test "should get internal_server_error" do
    get errors_internal_server_error_url
    assert_response :error
  end
end
