class User < ApplicationRecord
  has_secure_password
  has_secure_token :embed_token

  has_many :sessions, dependent: :destroy
  has_many :habits, -> { order(:position, :created_at) }, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def ensure_embed_token!
    regenerate_embed_token if embed_token.blank?
    embed_token
  end
end
