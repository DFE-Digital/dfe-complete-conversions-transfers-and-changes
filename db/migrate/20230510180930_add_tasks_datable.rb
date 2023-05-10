class AddTasksDatable < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :tasks_data_id, :uuid
    add_column :projects, :tasks_data_type, :string

    Project.all.each do |project|
      project.tasks_data_id = project.task_list_id
      project.tasks_data_type = "Conversion::TasksData"
      project.save!(validate: false)
    end
  end
end
