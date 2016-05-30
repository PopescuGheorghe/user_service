class AuthKey
  include HTTParty
  base_uri ENV['authorization_service']

  def generate_auth_key(id)
    self.class.post(
      '/generate_key',
      body: {
        id: id
      }
    )
  end

  def delete_key(id)
    self.class.delete("/delete_key/#{id}")
  end
end
