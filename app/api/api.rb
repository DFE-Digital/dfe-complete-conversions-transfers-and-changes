class Api < Grape::API
  prefix "api"
  format :json
  mount V1::Healthcheck
  mount V1::Auth
end
