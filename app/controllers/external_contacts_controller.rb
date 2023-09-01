class ExternalContactsController < ApplicationController
  include Projectable

  def index
    @grouped_contacts = @project.contacts.by_name.group_by(&:category).with_indifferent_access
  end

  def new
    authorize @project, :new_contact?
    @contact = Contact::Project.new(project: @project)
  end

  def create
    authorize @project, :new_contact?
    @contact = Contact::Project.new(project: @project, **contact_params.except(:establishment_main_contact))

    if @contact.valid?
      @contact.save
      set_establishment_main_contact(@contact)

      redirect_to project_contacts_path(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    authorize @contact

    @users = User.all
  end

  def update
    @contact = Contact.find(params[:id])
    authorize @contact

    set_establishment_main_contact(@contact)
    @contact.assign_attributes(contact_params.except(:establishment_main_contact))

    if @contact.valid?
      @contact.save
      redirect_to project_contacts_path(@project), notice: I18n.t("contact.update.success")
    else
      render :edit
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    authorize @contact

    @contact.destroy

    redirect_to project_contacts_path(@project), notice: I18n.t("contact.destroy.success")
  end

  def confirm_destroy
    @contact = Contact.find(params[:contact_id])
    authorize @contact
  end

  private def contact_params
    params.require(:contact_project).permit(:name, :organisation_name, :title, :category, :email, :phone, :establishment_main_contact)
  end

  private def set_establishment_main_contact(contact)
    project = Project.find(contact.project_id)
    return unless project

    if contact_params[:establishment_main_contact] == "1"
      project.update(establishment_main_contact_id: contact.id)
    else
      project.update(establishment_main_contact_id: nil)
    end
  end
end
