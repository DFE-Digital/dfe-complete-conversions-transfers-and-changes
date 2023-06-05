class AddFundingAgreementLettersContactIdToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :funding_agreement_contact_id, :uuid
  end
end
