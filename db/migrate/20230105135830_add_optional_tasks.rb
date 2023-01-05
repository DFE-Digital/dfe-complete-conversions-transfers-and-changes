class AddOptionalTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :articles_of_association_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :church_supplemental_agreement_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :deed_of_variation_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :direction_to_transfer_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :master_funding_agreement_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :one_hundred_and_twenty_five_year_lease_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :subleases_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :tenancy_at_will_not_applicable, :boolean
    add_column :conversion_voluntary_task_lists, :trust_modification_order_not_applicable, :boolean
  end
end
