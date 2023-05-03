class LocalAuthoritiesController < ApplicationController
  def index
    @local_authorities = LocalAuthority.all.order(:name)
  end

  def show
    @local_authority = LocalAuthority.find(params[:id])
  end

  def edit
    @local_authority = LocalAuthority.find(params[:id])
  end

  def update
    @local_authority = LocalAuthority.find(params[:id])
    @local_authority.assign_attributes(local_authority_params)

    if @local_authority.valid?
      @local_authority.update(local_authority_params)

      redirect_to local_authority_path(@local_authority), notice: I18n.t("local_authority.update.success")
    else
      render :edit
    end
  end

  private def local_authority_params
    params.require(:local_authority)
      .permit(:code, :address_1, :address_2, :address_3, :address_town, :address_county, :address_postcode)
  end
end
