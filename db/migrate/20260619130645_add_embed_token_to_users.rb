class AddEmbedTokenToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :embed_token, :string unless column_exists?(:users, :embed_token)
    add_index :users, :embed_token, unique: true unless index_exists?(:users, :embed_token)
  end

  def down
    remove_index :users, :embed_token if index_exists?(:users, :embed_token)
    remove_column :users, :embed_token if column_exists?(:users, :embed_token)
  end
end
