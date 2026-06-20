require "test_helper"

class PublicEmbedsControllerTest < ActionDispatch::IntegrationTest
  test "shows a read-only public embed" do
    user = users(:one)

    get public_embed_url(user.ensure_embed_token!)

    assert_response :success
    assert_nil response.headers["X-Frame-Options"]
    assert_equal "frame-ancestors *", response.headers["Content-Security-Policy"]
    assert_select "link[rel='stylesheet'][href*='tailwind']"
    assert_select "h2", text: habits(:one).name
    assert_select "form", count: 0
  end

  test "rejects an invalid token" do
    get public_embed_url("invalid")

    assert_response :not_found
  end
end
