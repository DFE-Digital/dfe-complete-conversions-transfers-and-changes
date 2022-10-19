class AddSlugToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :slug, :string
    Task.all.each do |task|
      task.update!(slug: task.title.parameterize)
    end
  end
end
