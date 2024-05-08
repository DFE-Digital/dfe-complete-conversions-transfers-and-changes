module V1
  class Healthcheck < Grape::API
    desc "Api healthcheck endpoint returns 'OK'"
    get :healthcheck do
      {status: "OK"}
    end
  end
end
