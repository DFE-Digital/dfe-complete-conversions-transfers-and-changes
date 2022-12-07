class Conversion::Voluntary::TasksController < ApplicationController
  def index
    @project = Project.find(params["id"])
    @task_list = Conversion::Voluntary::TaskList.new(@project)
    @sections = @task_list.sections
  end

  def edit
    @project = Project.find(params["id"])
    @task_list = Conversion::Voluntary::TaskList.new(@project)
    @task = TaskOneForm.new(@project)
    section_template = params["section_slug"].underscore
    task_template = params["task_slug"].underscore

    section_slug = params["section_slug"]
    task_slug = params["task_slug"]

    if @task_list.sections.find { |section| section.slug == section_slug }
      render "conversion/voluntary/tasks/#{section_template}/#{task_template}"
    else
      render "pages/page_not_found", status: 404
    end
  end

  def update
    @project = Project.find(params["id"])
    @task_list = Conversion::Voluntary::TaskList.new(@project)
    @task = TaskOneForm.new(@project)
    @task.update(params)

    redirect_to conversion_voluntary_tasks_path(@project), notice: "woop"
  end
end


class TaskOneForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_reader :details

  def initialize(project)
    @details = project.details
  end

  delegate :action_one_for_task_one_in_section_one,
    :detail_one_for_task_one_in_section_two,
    :land_issues_trust_modification,
    to: :details

  def update(params)
    details_params = params.require("task_one_form").permit("detail_one_for_task_one_in_section_two", "action_one_for_task_one_in_section_one", "land_issues_trust_modification")
    details.update(details_params)
  end
end
