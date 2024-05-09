module AuthHelpers
  def authenticate!
    error!("Unauthorized. Invalid or expired token.", 401) unless valid_token
  end

  def valid_token
    api_key = headers["Apikey"]
    return false unless api_key.present?

    token = ApiKey.find_by(api_key: api_key)
    token && !token.expired?
  end
end
