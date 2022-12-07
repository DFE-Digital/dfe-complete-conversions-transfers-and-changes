class AddTestAttributesToDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_details, :action_one_for_task_one_in_section_one, :boolean
    add_column :conversion_details, :detail_one_for_task_one_in_section_two, :text
    add_column :conversion_details, :land_issues_trust_modification, :text
  end
end
