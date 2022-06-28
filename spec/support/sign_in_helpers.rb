module SignInHelpers
  def mock_auth_with_user(user_email_address)
    User.create!(email: user_email_address)
    OmniAuth.config.mock_auth[:microsoft_graph] = OmniAuth::AuthHash.new({
      info: {
        email: user_email_address
      }
    })
    OmniAuth.config.test_mode = true
  end
end
