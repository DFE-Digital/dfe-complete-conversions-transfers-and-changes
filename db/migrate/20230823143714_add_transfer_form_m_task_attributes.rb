class AddTransferFormMTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :form_m_received_form_m, :boolean
    add_column :transfer_tasks_data, :form_m_received_title_plans, :boolean
    add_column :transfer_tasks_data, :form_m_cleared, :boolean
    add_column :transfer_tasks_data, :form_m_signed, :boolean
    add_column :transfer_tasks_data, :form_m_saved, :boolean
  end
end
