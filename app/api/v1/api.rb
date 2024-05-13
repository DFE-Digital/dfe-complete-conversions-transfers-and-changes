module V1
  class Api < Grape::API
    version "v1", using: :path

    mount Auth
    mount Healthcheck
    mount Conversions
  end
end
