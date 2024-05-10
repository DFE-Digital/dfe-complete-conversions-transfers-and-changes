class Api < Grape::API
  prefix "api"
  format :json
  mount V1::Api
end
