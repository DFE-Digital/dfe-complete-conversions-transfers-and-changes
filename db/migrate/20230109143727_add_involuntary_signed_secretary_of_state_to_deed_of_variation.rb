class AddInvoluntarySignedSecretaryOfStateToDeedOfVariation < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :deed_of_variation_sent, :boolean
    add_column :conversion_involuntary_task_lists, :deed_of_variation_signed_secretary_state, :boolean
  end
end
