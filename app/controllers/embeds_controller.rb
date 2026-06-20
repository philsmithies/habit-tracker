class EmbedsController < ApplicationController
  def show
    @embed_url = public_embed_url(Current.user.ensure_embed_token!)
    @embed_code = %(<iframe src="#{@embed_url}" width="100%" height="720" frameborder="0" loading="lazy"></iframe>)
  end

  def update
    Current.user.regenerate_embed_token
    redirect_to embed_path, notice: "The old embed link has been disabled."
  end
end
