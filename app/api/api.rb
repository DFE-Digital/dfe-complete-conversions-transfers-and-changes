class Api < Grape::API
  helpers AuthHelpers

  prefix "api"
  format :json
  mount V1::Api

  add_swagger_documentation \
    info: {
      title: "Complete conversions, transfers and changes API"
    },
    mount_path: "/swagger",
    version: "0.0.1", # the semversion of the API
    security_definitions: {
      api_key: {
        type: "apiKey",
        name: "Apikey",
        in: "header"
      }
    }
end
