class ContactsController < ApplicationController
  before_action :find_project
  before_action :find_contacts, only: :index

  def index
  end

  def new
    @contact = Contact.new(project: @project)
  end

  def create
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

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_contacts
    @contacts = Contact.where(project: @project)
  end

  private def contact_params
    params.require(:contact).permit(:name, :title, :email, :phone)
  end
end
