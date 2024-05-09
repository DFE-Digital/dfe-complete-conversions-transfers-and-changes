module V1
  class Auth < Grape::API
    helpers AuthHelpers

    desc "Authenticate endpoint"
    get :auth do
      authenticate!
      {status: "OK"}
    end
  end
end
