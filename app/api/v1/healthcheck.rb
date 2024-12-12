class V1::Healthcheck < Grape::API
  content_type :txt, "text/plain"

  desc "Api healthcheck endpoint checks db connection and returns 'Healthy' or 'Unhealthy'" do
    tags ["miscellaneous"]
  end

  get :healthcheck do
    content_type "text/plain"
    body "Healthy" if ActiveRecord::Base.connected?

    "Unhealthy"
  end
end
