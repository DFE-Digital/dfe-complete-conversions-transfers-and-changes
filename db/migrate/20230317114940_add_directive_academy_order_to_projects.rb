class AddDirectiveAcademyOrderToProjects < ActiveRecord::Migration[7.0]
  def up
    add_column :projects, :directive_academy_order, :boolean, default: false

    Project.all.each do |project|
      project.directive_academy_order = directive_academy_order(project)
      project.save(validate: false)
    end
  end

  def down
    remove_column :projects, :directive_academy_order, :boolean
  end

  def directive_academy_order(project)
    return false if project.task_list_type == "Conversion::Voluntary::TaskList"
    return true if project.task_list_type == "Conversion::Involuntary::TaskList"
  end
end
