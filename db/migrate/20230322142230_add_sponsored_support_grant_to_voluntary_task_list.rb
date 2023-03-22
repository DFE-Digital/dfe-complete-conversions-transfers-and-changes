class AddSponsoredSupportGrantToVoluntaryTaskList < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :sponsored_support_grant_eligibility, :boolean
    add_column :conversion_voluntary_task_lists, :sponsored_support_grant_payment_amount, :boolean
    add_column :conversion_voluntary_task_lists, :sponsored_support_grant_payment_form, :boolean
    add_column :conversion_voluntary_task_lists, :sponsored_support_grant_send_information, :boolean
    add_column :conversion_voluntary_task_lists, :sponsored_support_grant_inform_trust, :boolean
    add_column :conversion_voluntary_task_lists, :sponsored_support_grant_not_applicable, :boolean
  end
end
