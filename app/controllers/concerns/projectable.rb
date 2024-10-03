module Projectable
  extend ActiveSupport::Concern

  included do
    before_action :find_project, :append_project_view_path
  end

  private def find_project
    raise ActiveRecord::RecordNotFound unless valid_uuid?

    @project = Project.find(params[:project_id])
  end

  private def append_project_view_path
    return unless @project

    case @project.type
    when "Conversion::Project"
      append_view_path "app/views/conversions"
    when "Transfer::Project"
      append_view_path "app/views/transfers"
    end
  end

  private def valid_uuid?
    /[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/i.match(params[:project_id])
  end
end
