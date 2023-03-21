class AddSponsorTrustRequiredToProjects < ActiveRecord::Migration[7.0]
  def up
    add_column :projects, :sponsor_trust_required, :boolean, default: false

    Project.all.each do |project|
      project.sponsor_trust_required = sponsor_trust_required(project)
      project.save(validate: false)
    end
  end

  def down
    remove_column :projects, :sponsor_trust_required, :boolean
  end

  def sponsor_trust_required(project)
    return false if project.task_list_type == "Conversion::Voluntary::TaskList"
    return true if project.task_list_type == "Conversion::Involuntary::TaskList"
  end
end
