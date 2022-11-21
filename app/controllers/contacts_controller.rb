class ContactsController < ApplicationController
  before_action :find_project
  before_action :find_grouped_contacts, only: :index

  def index
  end

  def new
    @contact = Contact.new(project: @project)
  end

  def create
    @contact = Contact.new(project: @project, **contact_params)

    if @contact.valid?
      @contact.save

      redirect_to conversion_project_contacts_path(@project), notice: I18n.t("contact.create.success")
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
      redirect_to conversion_project_contacts_path(@project), notice: I18n.t("contact.update.success")
    else
      render :edit
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    redirect_to conversion_project_contacts_path(@project), notice: I18n.t("contact.destroy.success")
  end

  def confirm_destroy
    @contact = Contact.find(params[:contact_id])
  end

  private def find_project
    @project = ConversionProject.find(params[:conversion_project_id])
  end

  private def find_grouped_contacts
    @contacts = Contact.where(conversion_project: @project).group_by(&:category)
  end

  private def contact_params
    params.require(:contact).permit(:name, :title, :category, :email, :phone)
  end
end
