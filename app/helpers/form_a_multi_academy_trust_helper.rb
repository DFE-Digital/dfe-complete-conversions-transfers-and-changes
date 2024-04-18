module FormAMultiAcademyTrustHelper
  def projects_establishment_name_list(project_group)
    name_list = project_group.projects.map do |project|
      project.establishment.name
    end
    name_list.join("; ")
  end
end
