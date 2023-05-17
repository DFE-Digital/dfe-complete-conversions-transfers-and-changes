class LocalAuthoritiesController < ApplicationController
  def index
    @local_authorities = LocalAuthority.all.order(:name)
  end

  def show
    @local_authority = LocalAuthority.find(params[:id])
    @director_of_child_services = @local_authority.director_of_child_services
  end

  def new
    authorize LocalAuthority
    @local_authority = LocalAuthority.new
  end

  def create
    authorize LocalAuthority
    @local_authority = LocalAuthority.new(local_authority_params)

    if @local_authority.valid?
      @local_authority.save

      redirect_to local_authority_path(@local_authority), notice: I18n.t("local_authority.create.success")
    else
      render :new
    end
  end

  def edit
    authorize LocalAuthority
    @local_authority = LocalAuthority.find(params[:id])
    @director_of_child_services = @local_authority.director_of_child_services || Contact::DirectorOfChildServices.new
  end

  def update
    authorize LocalAuthority
    @local_authority = LocalAuthority.find(params[:id])
    @local_authority.assign_attributes(local_authority_params)

    if @local_authority.valid?
      @local_authority.update(local_authority_params)

      redirect_to local_authority_path(@local_authority), notice: I18n.t("local_authority.update.success")
    else
      render :edit
    end
  end

  def destroy
    authorize LocalAuthority
    @local_authority = LocalAuthority.find(params[:id])

    @local_authority.destroy

    redirect_to local_authorities_path, notice: I18n.t("local_authority.destroy.success")
  end

  def confirm_destroy
    authorize LocalAuthority
    @local_authority = LocalAuthority.find(params[:local_authority_id])
  end

  private def local_authority_params
    params.require(:local_authority)
      .permit(:name, :code, :address_1, :address_2, :address_3, :address_town, :address_county, :address_postcode,
        director_of_child_services_attributes: [:name, :email, :title, :phone])
  end
end
