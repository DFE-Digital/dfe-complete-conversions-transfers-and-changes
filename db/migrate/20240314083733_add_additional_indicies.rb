class AddAdditionalIndicies < ActiveRecord::Migration[7.0]
  def change
    add_index :local_authorities, :code
    add_index :projects, :tasks_data_id
    add_index :projects, :tasks_data_type
    add_index :significant_date_histories, :project_id
  end
end
