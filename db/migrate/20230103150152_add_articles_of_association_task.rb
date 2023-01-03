class AddArticlesOfAssociationTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :articles_of_association_received, :boolean
    add_column :conversion_voluntary_task_lists, :articles_of_association_cleared, :boolean
    add_column :conversion_voluntary_task_lists, :articles_of_association_signed, :boolean
    add_column :conversion_voluntary_task_lists, :articles_of_association_saved, :boolean
  end
end
