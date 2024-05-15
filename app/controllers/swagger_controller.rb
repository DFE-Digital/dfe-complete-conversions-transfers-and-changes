class SwaggerController < ApplicationController
  skip_before_action :redirect_unauthenticated_user

  layout "swagger"

  # Allow unsafe inline styles is the only way to get Swagger UI to work
  # we only do so for this controller
  content_security_policy do |policy|
    policy.style_src_elem :self, :unsafe_inline
  end

  def show
    # Action renders the show template only
  end
end
