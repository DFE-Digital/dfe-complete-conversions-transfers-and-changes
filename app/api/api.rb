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
    mount_path: "/swagger",
    host: proc { |request| request.host_with_port.to_s },
    doc_version: "1.0.0-alpha", # the semversion of the API, this is the 'version' key
    security_definitions: {
      api_key: {
        type: "apiKey",
        name: "ApiKey",
        in: "header"
      }
    },
    security: [
      {
        api_key: []
      }
    ],
    consumes: ["application/json"],
    produces: ["application/json"],
    tags: [
      {name: "conversions", description: "Conversion projects"},
      {name: "transfers", description: "Transfer projects"},
      {name: "miscellaneous", description: "Miscellaneous"}
    ]
end
