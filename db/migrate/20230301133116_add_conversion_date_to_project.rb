class AddConversionDateToProject < ActiveRecord::Migration[7.0]
  def up
    add_column :projects, :conversion_date, :date

    Project.find_each do |project|
      project.update(conversion_date: project.task_list.stakeholder_kick_off_confirmed_conversion_date)
    end
  end

  def down
    remove_column :projects, :conversion_date, :date
  end
end
