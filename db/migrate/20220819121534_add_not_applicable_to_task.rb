class AddNotApplicableToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :not_applicable, :boolean, default: false
  end
end
