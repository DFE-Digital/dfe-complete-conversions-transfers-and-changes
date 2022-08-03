if defined?(Dotenv)
  Dotenv.require_keys(
    "AZURE_APPLICATION_CLIENT_ID",
    "AZURE_APPLICATION_CLIENT_SECRET",
    "AZURE_TENANT_ID"
  )
end
