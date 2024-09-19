module V1
  class Api < Grape::API
    version "v1", using: :path

    mount Healthcheck
    mount Conversions
    mount Transfers
  end
end
