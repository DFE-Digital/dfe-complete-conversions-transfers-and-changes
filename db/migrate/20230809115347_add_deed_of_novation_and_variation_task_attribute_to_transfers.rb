class AddDeedOfNovationAndVariationTaskAttributeToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_received, :boolean
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_cleared, :boolean
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_signed_outgoing_trust, :boolean
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_signed_incoming_trust, :boolean
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_saved, :boolean
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_signed_secretary_state, :boolean
    add_column :transfer_tasks_data, :deed_of_novation_and_variation_sent, :boolean
  end
end
