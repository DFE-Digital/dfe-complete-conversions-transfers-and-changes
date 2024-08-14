class ExternalContacts::OtherContactsController < ApplicationController
  include Projectable

  def create
    authorize @project, :new_contact?
    @contact = Contact::CreateProjectContactForm.new(contact: Contact::Project.new, project: @project, args: contact_params)
    if @contact.save
      redirect_to project_contacts_path(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  private def contact_params
    params.require(:contact_create_project_contact_form).permit(:name, :email, :phone, :organisation_name, :title, :primary_contact_for_category, :category)
  end
end
