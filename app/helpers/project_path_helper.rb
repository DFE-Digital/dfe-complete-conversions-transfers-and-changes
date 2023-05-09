module ProjectPathHelper
  def path_to_project(project)
    return conversions_voluntary_project_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_project_task_list(project)
    return conversions_voluntary_project_task_list_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_project_notes(project)
    return conversions_voluntary_project_notes_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_project_information(project)
    return conversions_voluntary_project_information_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_project_contacts(project)
    return conversions_voluntary_project_contacts_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_project_internal_contacts(project)
    return conversions_voluntary_project_internal_contacts_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_team_lead_project_assignment(project)
    return conversions_voluntary_project_assign_team_lead_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_regional_delivery_officer_project_assignment(project)
    return conversions_voluntary_project_assign_regional_delivery_officer_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_assigned_to_project_assignment(project)
    return conversions_voluntary_project_assign_assigned_to_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end

  def path_to_new_conversion_date(project)
    return conversions_voluntary_project_conversion_date_path(project) if project.task_list_type == "Conversion::Voluntary::TaskList"
  end
end
