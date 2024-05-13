class V1::Auth < Grape::API
  desc "Authenticate endpoint"
  get :auth do
    authenticate!
    {status: "OK"}
  end
end
