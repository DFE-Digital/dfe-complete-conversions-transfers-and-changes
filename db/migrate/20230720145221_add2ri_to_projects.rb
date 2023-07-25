class Add2riToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :two_requires_improvement, :boolean, default: false
  end
end
