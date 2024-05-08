class Api < Grape::API
  prefix "api"
  format :json
  mount V1::Healthcheck
end
