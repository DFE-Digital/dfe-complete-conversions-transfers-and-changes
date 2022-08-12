class ContactsController < ApplicationController
  before_action :find_project
  before_action :find_contacts, only: :index

  def index
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_contacts
    @contacts = Contact.where(project: @project)
  end
end
