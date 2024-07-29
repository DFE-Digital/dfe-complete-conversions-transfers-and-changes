class AddSentFieldToArticlesOfAssociationTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :articles_of_association_sent, :boolean
    add_column :transfer_tasks_data, :articles_of_association_sent, :boolean
  end
end
