class ContactsController < ApplicationController
  before_action :find_project

  def index
    @grouped_contacts = @project.contacts.by_name.group_by(&:category).with_indifferent_access
  end

  def new
    authorize @project, :new_contact?
    @contact = Contact.new(project: @project)
  end

  def create
    authorize @project, :new_contact?
    @contact = Contact.new(project: @project, **contact_params)

    if @contact.valid?
      @contact.save

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

    @contact.assign_attributes(contact_params)

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

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def contact_params
    params.require(:contact).permit(:name, :organisation_name, :title, :category, :email, :phone)
  end
end
