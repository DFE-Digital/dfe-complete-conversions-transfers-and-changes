class RenameTaskActionOnDeedNovationVariation < ActiveRecord::Migration[7.0]
  def change
    rename_column :transfer_tasks_data, :deed_of_novation_and_variation_sent, :deed_of_novation_and_variation_save_after_sign
  end
end
