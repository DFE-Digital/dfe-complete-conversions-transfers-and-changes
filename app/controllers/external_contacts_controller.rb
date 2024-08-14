class ExternalContactsController < ApplicationController
  include Projectable

  def index
    @grouped_contacts = ContactsFetcherService.new(@project).all_project_contacts_grouped
  end

  def new
    authorize @project, :new_contact?

    @contact_form = if @project.is_a?(Conversion::Project)
      NewConversionContactForm.new
    else
      NewTransferContactForm.new
    end
  end

  def create
    authorize @project, :new_contact?

    case contact_type_params
    when "headteacher"
      @contact = Contact::CreateHeadteacherContactForm.new(contact: Contact::Project.new, project: @project)
      render "external_contacts/headteachers/new"
    when "incoming_trust_ceo"
      @contact = Contact::CreateIncomingTrustCeoContactForm.new(contact: Contact::Project.new, project: @project)
      render "external_contacts/incoming_trust_ceos/new"
    when "outgoing_trust_ceo"
      @contact = Contact::CreateOutgoingTrustCeoContactForm.new(contact: Contact::Project.new, project: @project)
      render "external_contacts/outgoing_trust_ceos/new"
    when "chair_of_governors"
      @contact = Contact::CreateChairOfGovernorsContactForm.new(contact: Contact::Project.new, project: @project)
      render "external_contacts/chair_of_governors/new"
    when "other"
      @contact = Contact::CreateProjectContactForm.new(contact: Contact::Project.new, project: @project)
      render "external_contacts/other_contacts/new"
    else
      not_found_error
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

  private def contact_type_params
    if @project.is_a?(Conversion::Project)
      conversion_contact_params["contact_type"]
    else
      transfer_contact_params["contact_type"]
    end
  end

  private def contact_params
    params.require(:contact_create_project_contact_form).permit(:name, :organisation_name, :title, :category, :email, :phone, :primary_contact_for_category)
  end

  private def conversion_contact_params
    params.require(:new_conversion_contact_form).permit(:contact_type)
  end

  private def transfer_contact_params
    params.require(:new_transfer_contact_form).permit(:contact_type)
  end
end
