module SignInHelpers
  def mock_successful_authentication(email_address)
    OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
      info: {
        email: email_address
      },
      uid: "b5095c3e-0141-4478-81ad-99d0fbd087ed"
    })
    OmniAuth.config.test_mode = true
  end

  def mock_unsuccessful_authentication
    OmniAuth.config.mock_auth[:azure_activedirectory_v2] = :invalid_credentials
    OmniAuth.config.test_mode = true
  end
end
