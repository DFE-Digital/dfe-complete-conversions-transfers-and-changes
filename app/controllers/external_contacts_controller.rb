class ExternalContactsController < ApplicationController
  include Projectable

  def index
    @grouped_contacts = ContactsFetcherService.new(@project).all_project_contacts_grouped
  end

  def new
    authorize @project, :new_contact?
    @contact = Contact::CreateProjectContactForm.new(contact: Contact::Project.new, project: @project)
  end

  def create
    authorize @project, :new_contact?
    @contact = Contact::CreateProjectContactForm.new(contact: Contact::Project.new, project: @project, args: contact_params)

    if @contact.save
      redirect_to project_contacts_path(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  def edit
    @existing_contact = Contact.find(params[:id])
    authorize @existing_contact

    @contact = Contact::CreateProjectContactForm.new(contact: @existing_contact, project: @project)
  end

  def update
    @existing_contact = Contact.find(params[:id])
    authorize @existing_contact

    @contact = Contact::CreateProjectContactForm.new(contact: @existing_contact, project: @project, args: contact_params)

    if @contact.save
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
    params.require(:contact_create_project_contact_form).permit(:name, :organisation_name, :title, :category, :email, :phone, :primary_contact_for_category)
  end
end
