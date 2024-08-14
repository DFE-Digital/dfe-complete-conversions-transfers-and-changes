class ExternalContacts::OutgoingTrustCeosController < ApplicationController
  include Projectable

  def create
    authorize @project, :new_contact?
    @contact = Contact::CreateOutgoingTrustCeoContactForm.new(contact: Contact::Project.new, project: @project, args: contact_params)
    if @contact.save
      redirect_to project_contacts_path(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  private def contact_params
    params.require(:contact_create_outgoing_trust_ceo_contact_form).permit(:name, :email, :phone, :primary_contact_for_category)
  end
end
