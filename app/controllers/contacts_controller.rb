class ContactsController < ApplicationController
  before_action :find_project

  def index
    @grouped_contacts = @project.contacts.by_name.group_by(&:category).with_indifferent_access
  end

  def new
    @contact = Contact.new(project: @project)
  end

  def create
    @contact = Contact.new(project: @project, **contact_params)

    if @contact.valid?
      @contact.save

      redirect_to helpers.path_to_project_contacts(@project), notice: I18n.t("contact.create.success")
    else
      render :new
    end
  end

  def edit
    @contact = Contact.find(params[:id])

    @users = User.all
  end

  def update
    @contact = Contact.find(params[:id])

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
    @contact.destroy

    redirect_to project_contacts_path(@project), notice: I18n.t("contact.destroy.success")
  end

  def confirm_destroy
    @contact = Contact.find(params[:contact_id])
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def contact_params
    params.require(:contact).permit(:name, :organisation_name, :title, :category, :email, :phone)
  end
end
