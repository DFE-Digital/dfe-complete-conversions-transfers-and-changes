class AddTransferDeedOfVariationTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :deed_of_variation_received, :boolean
    add_column :transfer_tasks_data, :deed_of_variation_cleared, :boolean
    add_column :transfer_tasks_data, :deed_of_variation_signed, :boolean
    add_column :transfer_tasks_data, :deed_of_variation_saved, :boolean
    add_column :transfer_tasks_data, :deed_of_variation_sent, :boolean
    add_column :transfer_tasks_data, :deed_of_variation_signed_secretary_state, :boolean
    add_column :transfer_tasks_data, :deed_of_variation_not_applicable, :boolean
  end
end
