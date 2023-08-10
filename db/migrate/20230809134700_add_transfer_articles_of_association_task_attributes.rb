class AddTransferArticlesOfAssociationTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :articles_of_association_received, :boolean
    add_column :transfer_tasks_data, :articles_of_association_cleared, :boolean
    add_column :transfer_tasks_data, :articles_of_association_signed, :boolean
    add_column :transfer_tasks_data, :articles_of_association_saved, :boolean
    add_column :transfer_tasks_data, :articles_of_association_not_applicable, :boolean
  end
end
