class ProjectController < ApplicationController

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.create()

    # Load the current flow definition
    flow = Flow.load_flow("conversion")

    # Loop through the definition and load things into the database
    flow[:sections].each_with_index do |section, index|
      section_instance = Section.create(
        project: project,
        title: section['title'],
        order: index+1
        )

      section['tasks'].each_with_index do |task, index|
        Task.create(
          section: section_instance,
          title: task['title'],
          order: index+1
          )
      end
    end

    redirect_to project_path(project)
  end
end
