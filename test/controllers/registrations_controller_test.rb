require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "creates an account and signs in" do
    assert_difference [ -> { User.count }, -> { Session.count } ], 1 do
      post registration_url, params: {
        user: {
          email_address: "new@example.com",
          password: "secret-password",
          password_confirmation: "secret-password"
        }
      }
    end

    assert_redirected_to root_url
    assert cookies[:session_id].present?
  end
end
