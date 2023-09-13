class ExternalContactsController < ApplicationController
  include Projectable

  def index
    @grouped_contacts = @project.contacts.by_name.group_by(&:category).with_indifferent_access
  end

  def new
    authorize @project, :new_contact?
    @contact = Contact::CreateProjectContactForm.new({}, @project)
  end

  def create
    authorize @project, :new_contact?
    @contact = Contact::CreateProjectContactForm.new(contact_params, @project)

    if @contact.save
      redirect_to project_contacts_path(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  def edit
    @existing_contact = Contact.find(params[:id])
    authorize @existing_contact

    @contact = Contact::CreateProjectContactForm.new_from_contact({}, @project, @existing_contact)
    @users = User.all
  end

  def update
    @existing_contact = Contact.find(params[:id])
    authorize @existing_contact

    @contact = Contact::CreateProjectContactForm.new(contact_params, @project, @existing_contact)

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
    params.require(:contact_create_project_contact_form).permit(:name, :organisation_name, :title, :category, :email, :phone, :establishment_main_contact, :incoming_trust_main_contact)
  end
end
