class Api < Grape::API
  helpers AuthHelpers

  prefix "api"
  format :json
  mount V1::Api

  add_swagger_documentation \
    info: {
      title: "Complete conversions, transfers and changes API",
      description: "API to for the complete conversions, transfers and changes application.",
      contact_name: "Service Support",
      contact_email: "regionalservices.rg@education.gov.uk"
    },
    base_path: "/api",
    mount_path: "/swagger",
    host: proc { |request| request.host_with_port.to_s },
    version: "0.0.1", # the semversion of the API
    security_definitions: {
      api_key: {
        type: "apiKey",
        name: "Apikey",
        in: "header"
      }
    },
    consumes: ["application/json"],
    produces: ["application/json"],
    tags: [
      {name: "conversions", description: "Conversion projects"},
      {name: "transfers", description: "Transfer projects"},
      {name: "miscellaneous", description: "Miscellaneous"}
    ]
end
