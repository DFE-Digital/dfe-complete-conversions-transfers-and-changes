class V1::Healthcheck < Grape::API
  desc "Api healthcheck endpoint returns 'OK'" do
    tags ["miscellaneous"]
  end
  get :healthcheck do
    {status: "OK"}
  end
end
