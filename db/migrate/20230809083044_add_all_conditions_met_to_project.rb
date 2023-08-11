class AddAllConditionsMetToProject < ActiveRecord::Migration[7.0]
  def up
    add_column :projects, :all_conditions_met, :boolean, default: false

    if update_all_projects
      remove_column :conversion_tasks_data, :conditions_met_confirm_all_conditions_met, :boolean
    end
  end

  def down
    add_column :conversion_tasks_data, :conditions_met_confirm_all_conditions_met, :boolean

    if revert_all_projects
      remove_column :projects, :all_conditions_met, :boolean
    end
  end

  def update_all_projects
    Conversion::Project.all.each do |project|
      all_conditions_met = project&.tasks_data&.conditions_met_confirm_all_conditions_met || false
      project.update_attribute(:all_conditions_met, all_conditions_met)
    end
  end

  def revert_all_projects
    Conversion::Project.all.each do |project|
      all_conditions_met = project.all_conditions_met || false
      project.update_attribute(:all_conditions_met, all_conditions_met)
    end
  end
end
