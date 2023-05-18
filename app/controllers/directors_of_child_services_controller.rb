class DirectorsOfChildServicesController < ApplicationController
  def index
    @directors = Contact::DirectorOfChildServices
      .all
      .includes(:local_authority)
      .sort_by { |dcs| dcs.local_authority.name }
  end

  def edit
    authorize LocalAuthority

    @director = Contact::DirectorOfChildServices.find(params[:id])
    @local_authority = @director.local_authority
  end

  def update
    authorize LocalAuthority

    @director = Contact::DirectorOfChildServices.find(params[:id])
    @local_authority = @director.local_authority
    @director.assign_attributes(director_params)

    if @director.valid?
      @director.update(director_params)

      redirect_to directors_of_child_services_path, notice: t("directors_of_child_services.update.success", local_authority: @director.local_authority.name)
    else
      render :edit
    end
  end

  private def director_params
    params.require(:contact_director_of_child_services).permit(:name, :title, :email, :phone)
  end
end
