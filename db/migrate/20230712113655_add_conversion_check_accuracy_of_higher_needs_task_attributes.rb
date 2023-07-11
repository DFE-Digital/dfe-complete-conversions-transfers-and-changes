class AddConversionCheckAccuracyOfHigherNeedsTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :check_accuracy_of_higher_needs_confirm_number, :boolean
    add_column :conversion_tasks_data, :check_accuracy_of_higher_needs_confirm_published_number, :boolean
  end
end
