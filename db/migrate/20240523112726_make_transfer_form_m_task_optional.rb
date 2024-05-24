class MakeTransferFormMTaskOptional < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :form_m_not_applicable, :boolean
  end
end
