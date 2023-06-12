class ProjectsFetcher
  def sorted_openers(month, year)
    projects = Conversion::Project.opening_by_month_year(month, year)
    sort_by_conditions_met_and_name(projects)
  end

  private def sort_by_conditions_met_and_name(projects)
    projects.sort_by { |p| [p.all_conditions_met? ? 0 : 1, p.establishment.name] }
  end
end
