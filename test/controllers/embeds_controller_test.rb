require "test_helper"

class EmbedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "shows iframe code and preview" do
    get embed_url

    assert_response :success
    assert_select "link[rel='stylesheet'][href*='tailwind']"
    assert_select "textarea", text: /<iframe/
    assert_select "iframe[src=?]", public_embed_url(users(:one).reload.embed_token)
  end

  test "resetting the link changes the public token" do
    old_token = users(:one).ensure_embed_token!

    patch embed_url

    assert_redirected_to embed_url
    assert_not_equal old_token, users(:one).reload.embed_token
  end
end
