Rails.application.config.middleware.use OmniAuth::Builder do
  provider :azure_activedirectory_v2,
    {
      client_id: ENV["AZURE_APPLICATION_CLIENT_ID"],
      client_secret: ENV["AZURE_APPLICATION_CLIENT_SECRET"],
      tenant_id: ENV["AZURE_TENANT_ID"]
    }
end

OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = proc { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
