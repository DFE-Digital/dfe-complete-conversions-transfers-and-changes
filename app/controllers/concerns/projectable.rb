module Projectable
  extend ActiveSupport::Concern

  included do
    before_action :find_project, :append_project_view_path
  end

  private def find_project
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
end
