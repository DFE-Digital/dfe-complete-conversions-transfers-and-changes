class LocalAuthoritiesController < ApplicationController
  def index
    @local_authorities = LocalAuthority.all.order(:name)
  end

  def show
    @local_authority = LocalAuthority.find(params[:id])
  end
end
