class ExternalContacts::IncomingTrustCeosController < ApplicationController
  include Projectable

  def create
    authorize @project, :new_contact?
    @contact = Contact::CreateIncomingTrustCeoContactForm.new(contact: Contact::Project.new, project: @project, args: contact_params)
    if @contact.save
      redirect_to project_contacts_path(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  private def contact_params
    params.require(:contact_create_incoming_trust_ceo_contact_form).permit(:name, :email, :phone, :primary_contact_for_category)
  end
end
