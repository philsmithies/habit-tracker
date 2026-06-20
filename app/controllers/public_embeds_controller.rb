class PublicEmbedsController < ApplicationController
  allow_unauthenticated_access
  layout "embed"

  after_action :allow_iframe_embedding

  def show
    @user = User.find_by!(embed_token: params[:token])
    @habits = @user.habits.includes(:entries)
  end

  private
    def allow_iframe_embedding
      response.headers.delete("X-Frame-Options")
      response.headers["Content-Security-Policy"] = "frame-ancestors *"
    end
end
