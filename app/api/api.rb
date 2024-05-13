class Api < Grape::API
  helpers AuthHelpers

  prefix "api"
  format :json
  mount V1::Api
end
