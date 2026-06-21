require "test_helper"

class PwaControllerTest < ActionDispatch::IntegrationTest
  test "serves an installable manifest" do
    get pwa_manifest_url(format: :json)

    assert_response :success
    manifest = JSON.parse(response.body)
    assert_equal "standalone", manifest["display"]
    assert_equal "/", manifest["id"]
    assert_equal [ "192x192", "512x512", "512x512" ], manifest["icons"].pluck("sizes")
  end

  test "serves a service worker that does not cache page html" do
    get pwa_service_worker_url

    assert_response :success
    assert_includes response.body, "/offline.html"
    assert_includes response.body, 'event.request.mode === "navigate"'
    assert_includes response.body, 'url.pathname.startsWith("/assets/")'
  end
end
