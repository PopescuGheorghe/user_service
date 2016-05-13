class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
    add_column :users, :token_created_at, :datetime
  end
end
