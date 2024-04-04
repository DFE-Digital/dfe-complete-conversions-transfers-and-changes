class AddStateToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :state, :integer, default: 0, null: false

    ActiveRecord::Base.transaction do
      Project.all.each do |project|
        if !project.completed_at.nil?
          project.update!(state: 1)
        end
      end
    end
  end
end
